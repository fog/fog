module Fog
  module Compute
    class Openstack
      class Real

        def list_security_groups
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => 'os-security-groups.json'
          )
        end

      end

      class Mock



      end
    end
  end
end
