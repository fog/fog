require 'fog/core/model'

module Fog
  module HP
    class Network
      class SecurityGroupRule < Fog::Model
        identity :id

        attribute :security_group_id
        attribute :direction
        attribute :protocol
        attribute :port_range_min
        attribute :port_range_max
        attribute :remote_ip_prefix
        attribute :ethertype
        attribute :remote_group_id
        attribute :tenant_id

        def destroy
          requires :id
          service.delete_security_group_rule(id)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          merge_attributes(service.create_security_group_rule(security_group_id, direction, attributes).body['security_group_rule'])
          true
        end
      end
    end
  end
end
