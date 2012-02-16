module Fog
  module Compute
    class Openstack
      class Real

        def get_security_group(security_group_id)
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "os-security-groups/#{security_group_id}"
          )
        end

      end

      class Mock



      end
    end
  end
end
