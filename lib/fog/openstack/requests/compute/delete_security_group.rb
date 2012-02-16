module Fog
  module Compute
    class Openstack
      class Real

        def delete_security_group(security_group_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "os-security-groups/#{security_group_id}"
          )
        end

      end

      class Mock



      end
    end
  end
end
