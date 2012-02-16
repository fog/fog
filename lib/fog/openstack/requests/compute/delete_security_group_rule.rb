module Fog
  module Compute
    class Openstack
      class Real

        def delete_security_group_rule(security_group_rule_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "os-security-group-rules/#{security_group_rule_id}"
          )
        end

      end

      class Mock



      end
    end
  end
end
