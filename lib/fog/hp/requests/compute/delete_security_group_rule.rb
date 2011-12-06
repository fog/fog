module Fog
  module Compute
    class HP
      class Real

        # Delete a security group rule
        #
        # ==== Parameters
        # * id<~Integer> - id of the security group rule to delete
        #
        # {Openstack API Reference}[http://docs.openstack.org]
        def delete_security_group_rule(security_group_rule_id)
          request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => "os-security-group-rules/#{security_group_rule_id}"
          )
        end

      end

      class Mock

        def delete_security_group_rule(security_group_rule_id)
          response = Excon::Response.new

          sg_rule = nil
          self.data[:security_groups].each do |skey, sv|
            if sv['rules']
              sg_rule = sv['rules'].select { |r| r == security_group_rule_id }
            end
          end
          unless sg_rule.empty?
            self.data[:security_groups]["#{sg_rule.values.first['parent_group_id']}"]['rules'].delete(security_group_rule_id)
            response.status = 202
            response.body = "202 Accepted\n\nThe request is accepted for processing.\n\n   "
            response
          else
            raise Fog::Compute::HP::NotFound
          end
        end

      end
    end
  end
end
