# Creating servers (VMs) and templates

The basic server creation steps are detailed in the getting started tutorial.

Now let's do something a little bit more complex and probably more useful in
day-to-day operations. That is:

1. Uploading a VHD image.
2. Create a new template with it.
3. Spin a new server using the recently added template.

## Part I: Upload the VHD

Assuming we have an image file 'ubuntu.vhd' ready to be uploaded, let's create
the connection to the XenServer host and upload the image to the storage repository,
using SSH. The code also assumes that you have a file storage repository mounted
somewhere in /var/run/sr-mount/#{sr-UUID} (the standard XenServer base directory
for mounted storage repositories).

    require 'fog'                                                               
    require 'net/scp'
    require 'uuidtools'
    
    #
    # Create the connection to the XenServer host
    #
    xenserver = Fog::Compute.new({
      :provider           => 'XenServer',
      :xenserver_url      => 'xenserver-test',
      :xenserver_username => 'root',
      :xenserver_password => 'secret',
    })


We'll be uploading the image to the "Local File SR" storage repository, so
we need the reference to this SR (Storage Repository):
  
    sr = xenserver.storage_repositories.find { |sr| sr.name ==  "Local File SR" }

XenServer uses UUIDs to store images in the storage repositories, so we will
emulate that behavior, creating a new UUID for our image and uploading it.

    #
    # Use the excelent uuidtools gem to create the new UUID
    # for the image
    #
    image_uuid = UUIDTools::UUID.random_create.to_s


To upload the new image using SCP, we need the destination directory, where the
SR is mounted. In our case, the storage repository mount point is 
/var/run/sr-mount/#{sr.uuid} (where sr.uuid is the UUID of the storage
repository). We will upload the new image there:

    sr_mount_point = "/var/run/sr-mount/#{sr.uuid}"
    # Target image file path. We will upload the local image to the destination
    # using SCP
    destination = File.join(sr_mount_point, "#{image_uuid}.vhd")
    # source image, located in the current directory
    source = 'ubuntu.vhd'
    # Use the XenServer root credentials to upload
    Net::SSH.start('xenserver-test', 'root', :password => 'secret') do |ssh|              
      ssh.scp.upload!(source, destination) do |ch, name, sent, total|              
        # print progress
        p = (sent.to_f * 100 / total.to_f).to_i.to_s                        
        print "\rProgress: #{p}% completed"                     
      end                                                                   
    end 

We need to let the XenServer know, that there's a new image:

    sr.scan
 
Now that XenServer is aware of the new image, get its reference
and set the image name attribute to 'ubuntu-template'

    ubuntu_vdi = xenserver.vdis.find { |vdi| vdi.uuid == image_uuid }
    ubuntu_vdi.set_attribute 'name_label', 'ubuntu-template'

Good! the image is ready to be used.

## Part II: create the server template

We have the image ready to be used by our new template.

Templates are regular servers, so let's create one with 512 MB of RAM, 1 CPU
and a network card. The main difference with a regular server from an API 
point of view is that we will not start it.

We will also create the template as PV (paravirtual):

    server_mem = (512 * 1024 * 1024).to_s 
    server = xenserver.servers.new :name               => "ubuntu-template",
                                   # Required when using Server.new
                                   :affinity           => xenserver.hosts.first,
                                   :other_config       => {},
                                   :pv_bootloader      => 'pygrub',          # PV related
                                   :hvm_boot_policy    => '',                # PV related
                                   :pv_args            => '-- console=hvc0', # PV related
                                   :memory_static_max  => mem,
                                   :memory_static_min  => mem,
                                   :memory_dynamic_max => mem,                       
                                   :memory_dynamic_min => mem 
    server.save

We need to attach the disk image to a VBD and to the server

    xenserver.vbds.create :server => server, :vdi => ubuntu_vdi

Note that we're using Server.new here, instead of Server.create.
Server.create would start the server, and that's not what we want here.

Let's add the NIC (VIF or virtual interface) to the server.

I have a network in my XenServer named "Pool-wide network associated with eth0"
bridged to the physical eth0 NIC and I will attach the new NIC to that network.

Don't be scared by the VIF creation code. There are easier ways to create a
VIF, and we'll be dealing with that and some other cases in the networking 
tutorial (TODO).

First, let's find the network since we'll need the reference.

    net = xenserver.networks.find { |n| n.name == 'Pool-wide network associated with eth0' }

To create the VM VIF, we need to set some attributes and use the 
create_vif_custom request:

    vif_attr = {
      'MAC_autogenerated' => 'True',
      'VM'                => server.reference, # we need the VM reference here
      'network'           => net.reference, # we need the Network reference here
      'MAC'               => '', # ignored, since we use autogeneration
      'device'            => '0',
      'MTU'               => '0',
      'other_config'      => {},
      'qos_algorithm_type' => 'ratelimit',                                 
      'qos_algorithm_params' => {}
    }
    xenserver.create_vif_custom vif_attr
    

The template is now ready to be used and we can list it!

    xenserver.servers.custom_templates.find { |t| puts t.name }

## Party III: spin a new server using the brand new template

Now that we have the template in place, it's easy to create as many servers
as you want. All of them will share hardware specs with the template. That is,
512 MB of RAM, 1 CPU, 1 NIC attached to the 'Pool-wide network...':

    xenserver.servers.create :name => 'my-brand-new-server',
                             :template_name => 'ubuntu-template'


# The End

Pretty similar code is used by knife-xenserver (http://github.com/bvox/knife-xenserver)
to upload new templates. Have a look at it if you're interested, it's full of
examples and fog/xenserver tricks to manage XenServer/XCP hosts.

The full source code used in this tutorial is available at:

https://github.com/bvox/fog-xenserver-examples/blob/master/upload_template_and_create.rb

Enjoy!

