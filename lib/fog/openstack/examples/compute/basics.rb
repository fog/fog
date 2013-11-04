# OpenStack Compute (Nova) Example

require 'fog'

auth_url = "https://example.net/v2.0/tokens"
username = 'admin@example.net'
password = 'secret'
tenant   = 'My Compute Tenant' # String

compute_client ||= ::Fog::Compute.new(:provider           => :openstack,
                                      :openstack_api_key  => password  ,
                                      :openstack_username => username  ,
                                      :openstack_auth_url => auth_url  ,
                                      :openstack_tenant   => tenant)

# Create VM
# Options include metadata, availability zone, etc...

begin
  vm = compute_client.servers.create(name, image, flavor, options = {})
rescue => e
  puts JSON.parse(e.response.body)['badRequest']['message']
end

# Destroy VM

vm = compute_client.servers.get(vm.id) # Retrieve previously created vm by UUID
floating_ips = vm.all_addresses # fetch and release its floating IPs
floating_ips.each do |address|
  compute_client.disassociate_address(uuid, address['ip'])
  compute_client.release_address(address['id'])
end
vm.destroy

# Power operations helper

# vm.start / vm.stop / vm.pause should work after this
class Server < Fog::Compute::Server
  def start
    if state.downcase == 'paused'
      service.unpause_server(id) # resumes from frozen VM state
    else
      service.resume_server(id)  # resumes from hibernation
    end
  end

  def stop
    service.suspend_server(id) # hibernates the VM at hypervisor-level
  end

  def pause
    service.pause_server(id)   # stores VM state in RAM
  end
end

# Images available at tenant
image_names = compute_client.images.map { |image| image['name'] }


# Floating IP address pools available at tenant
compute_client.addresses.get_address_pools
# response.body #=> { 'name' => 'pool1' }, { 'name' => 'pool2' }

# VNC console
vm.console.body # returns VNC url

# "console" => {
#                "url"  => "http://vmvncserver:6080/vnc_auto.html?token=231",
#                "type" => "novnc"
#              }




