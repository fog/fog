module Fog
  module Identity
    class Openstack
      class Real

        def get_tenants
          
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "tenants"
          )
        end

      end

      class Mock



      end
    end
  end
end
