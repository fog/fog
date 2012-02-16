module Fog
  module Compute
    class Openstack
      class Real

        def list_all_addresses(server_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "os-floating-ips.json"
          )
          
        end

      end

      class Mock


      end
    end
  end
end
