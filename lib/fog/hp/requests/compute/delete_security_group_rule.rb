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

          self.data[:security_groups].each do |_, sgv|
            if sgv['rules']
              sg_rule = sgv['rules'].delete_if { |r| !r.nil? && r['id'] == security_group_rule_id }
              break if sg_rule
            end
          end

          if sg_rule && !sg_rule.empty?
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
