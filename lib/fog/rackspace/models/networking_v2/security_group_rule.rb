module Fog
  module Rackspace
    class NetworkingV2
      class SecurityGroupRule < Fog::Model

        identity :id

        attribute :direction
        attribute :ethertype
        attribute :port_range_max
        attribute :port_range_min
        attribute :protocol
        attribute :remote_group_id
        attribute :remote_ip_prefix
        attribute :security_group_id
        attribute :tenant_id

        def save
          data = unless self.id.nil?
            service.update_security_group_rule(self)
          else
            service.create_security_group_rule(self)
          end

          merge_attributes(data.body['security_group_rule'])
          true
        end

        def destroy
          requires :identity

          service.delete_security_group_rule(identity)
          true
        end
      end
    end
  end
end
