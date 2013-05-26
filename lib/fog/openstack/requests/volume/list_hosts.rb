module Fog
  module Volume
    class OpenStack
      
      class Real
        def list_hosts(filters = {})
          request(
            :expects => 200,
            :method  => 'GET',
            :path    => 'os-hosts',
            :query   => filters
          )
        end
      end

      class Mock
        def list_hosts(filters = {})
          Excon::Response.new(
            :status => 200,
            :body => {
              'hosts' => [
                {
                  'service-status' => 'available', 
                  'service' => 'cinder-volume', 
                  'zone' => 'nova', 
                  'service-state' => 'enabled', 
                  'host_name' => 'openstack-cinder-node', 
                  'last-update' => '2013-05-25T12:03:38.000000'
                }, 
                {
                  'service-status' => 'available', 
                  'service' => 'cinder-scheduler', 
                  'zone' => 'nova', 
                  'service-state' => 'enabled', 
                  'host_name' => 'openstack-cinder-node', 
                  'last-update' => '2013-05-25T12:03:36.000000'
                },
              ]
            }
          )
        end
      end

    end
  end
end