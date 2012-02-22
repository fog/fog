require 'fog/core/model'

module Fog
  module Compute
    class OpenStack

      class SecurityGroup < Fog::Model

        identity  :id

        attribute :name
        attribute :description
        attribute :rules
        attribute :tenant_id


        def save
          requires :name, :description
          data = connection.create_security_group(name, description)
          merge_attributes(data.body['security_group'])
          true
        end


        def destroy
          requires :id
          connection.delete_security_group(id)
          true
        end

        def create_security_group_rule(min, max, ip_protocol = "tcp", cidr = "0.0.0.0/0", group_id = nil)
          requires :id
          connection.create_security_group_rule(id, ip_protocol, min, max, cidr, group_id)
        end

        def delete_security_group_rule(rule_id)
          connection.delete_security_group_rule(rule_id)
          true
        end

      end
    end
  end
end
