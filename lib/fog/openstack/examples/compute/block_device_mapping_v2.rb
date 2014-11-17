# OpenStack Compute (Nova) Example

require 'fog'
require 'fog/openstack'

auth_url = "https://example.net/v2.0/tokens"
username = 'admin@example.net'
password = 'secret'
tenant   = 'My Compute Tenant' # String

compute_client ||= ::Fog::Compute.new(:provider           => :openstack,
                                      :openstack_api_key  => password  ,
                                      :openstack_username => username  ,
                                      :openstack_auth_url => auth_url  ,
                                      :openstack_tenant   => tenant)

vm = compute_client.servers.create(:name => name,
                                   :flavor_ref => flavor,
                                   :block_device_mapping => [
                                     {
                                       :api_ver => "v2",
                                       :device_name => "/dev/vda1",
                                       :source_type => "volume",
                                       :destination_type => "volume",
                                       :delete_on_termination => false,
                                       :uuid => cinder_uddi,
                                       :boot_index => 0
                                     }
                                   ]
                                   )
