require 'fog/core/model'

module Fog
  module Compute
    class HPV2

      class SecurityGroup < Fog::Model

        identity  :id

        attribute :name
        attribute :description
        attribute :rules
        attribute :tenant_id

        def destroy
          requires :id

          service.delete_security_group(id)
          true
        end

        def save
          requires :name, :description

          data = service.create_security_group(name, description)
          merge_attributes(data.body['security_group'])
          true
        end

        def authorize_port_range(range, options = {})
          requires :id

          ip_protocol = options[:ip_protocol] || "tcp"

          if options[:group]
            cidr = options[:cidr_ip] || "0.0.0.0/0"
          else
            group_id = options[:group].is_a?(SecurityGroup) ? options[:group].id : options[:group]
          end

          service.create_security_group_rule(id, ip_protocol, range.min, range.max, cidr, group_id)
        end


        def create_rule(range, ip_protocol = "tcp", cidr = "0.0.0.0/0", group_id=nil)
          requires :id
          service.create_security_group_rule(id, ip_protocol, range.min, range.max, cidr, group_id)
        end

        def delete_rule(rule_id)
          service.delete_security_group_rule(rule_id)
          true
        end

        def delete_all_rules()
          self.rules.each do |rule|
            delete_rule(rule['id'])
          end
          true
        end
      end
    end
  end
end
