module Fog
  module HP
    class Network
      class Real
        # Delete a security group rule
        #
        # ==== Parameters
        # * 'security_group_rule_id'<~String> - UUId of the security group rule to delete
        def delete_security_group_rule(security_group_rule_id)
          request(
            :expects  => 204,
            :method   => 'DELETE',
            :path     => "security-group-rules/#{security_group_rule_id}"
          )
        end
      end

      class Mock
        def delete_security_group_rule(security_group_rule_id)
          response = Excon::Response.new
          if self.data[:security_group_rules][security_group_rule_id]
            self.data[:security_group_rules].delete(security_group_rule_id)
            response.status = 204
            response
          else
            raise Fog::HP::Network::NotFound
          end
        end
      end
    end
  end
end
