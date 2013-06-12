Shindo.tests('Fog::Volume[:openstack] | hosts requests', ['openstack']) do

  @hosts_format = {
    'service-status' => String,
    'service'        => String,
    'zone'           => String,
    'service-state'  => String,
    'host_name'      => String,
    'last-update'    => String,
  }

  @hosts_details_format = {
    'resource' => Hash,
  }
  
  tests('success') do
    tests('#list_hosts').formats({'hosts' => [@hosts_format]}) do
      Fog::Volume[:openstack].list_hosts.body
    end

    tests('#get_host_details').formats({'host' => [@hosts_details_format]}) do
      host = Fog::Volume[:openstack].list_hosts.body['hosts'].first
      Fog::Volume[:openstack].get_host_details(host['host_name']).body
    end
  end

end