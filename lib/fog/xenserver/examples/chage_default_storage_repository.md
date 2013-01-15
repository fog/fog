# How To Change the Default Storage Repository to File-based VHD-on-EXT3 

**NOTE: Requires fog > 1.8 (currently in development as of this writing)**

This tutorial explains how to convert a local Logical Volume Manager (LVM) 
based storage repository into a file-based (VHD) storage repository.

It's the fog/xenserver version of the original Citrix KB article:

http://support.citrix.com/article/ctx116324

To create this tutorial, I've used a vanilla XCP 1.6 ISO install in VirtualBox.

## Create the connection

```ruby
require 'fog'

conn = Fog::Compute.new({
  :provider => 'XenServer',
  :xenserver_url => '192.168.1.39',
  :xenserver_username => 'root',
  :xenserver_password => 'secret'
})
```

## Remove the LVM-backed storage repository (SR).

Find the default LVM storage repository:

```ruby
#
# Equivalent to:
# xe sr-list type=lvm
#
lvm_sr = nil 
conn.storage_repositories.each do |sr|
  lvm_sr = sr if sr.type == 'lvm'
end
```

Determine the UUID for your default SR's physical block device:

```ruby
#
# Equivalent to:
# xe pbd-list sr-uuid=your SR UUID
#
if lvm_sr
  conn.pbds.each do |pbd|
    # Unplug it if found
    # Equivalent to:
    # xe pbd-unplug uuid=your PBD UUID
    #
    pbd.unplug if pbd.storage_repository.uuid == lvm_sr.uuid
  end
  # Destroy the SR
  lvm_sr.destroy 
end
```

Create a new VHD-backed SR:

```ruby
#
# Equivalent to:
#
# xe sr-create content-type="local SR" \
#              host-uuid=5d189b7a-cd5e-4029-9940-d4daaa34633d \ 
#              type=ext device-config-device=/dev/sda3 shared=false \
#              name-label="Local File SR"
#
sr = conn.storage_repositories.create :name => 'Local File SR',
                                      :host => conn.hosts.first,
                                      :type => 'ext',
                                      :content_type => 'local SR',
                                      :device_config => { :device => '/dev/sda3' },
                                      :shared => false
```

Set your SR as the default SR on the system:

```ruby
#
# Equivalent command:
# xe pool-param-set suspend-image-SR='YOUR NEW SR UUID' uuid=bleh
#
conn.pools.first.default_storage_repository = sr
```

Set your SR as the default location for suspended VM images:

```ruby
#
# Equivalent command:
# xe pool-param-set suspend-image-SR= YOUR NEW SR UUID  uuid=bleh
#
conn.pools.first.suspend_image_sr = sr
```
