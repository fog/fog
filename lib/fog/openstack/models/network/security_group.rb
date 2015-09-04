require 'fog/openstack/models/model'

module Fog
  module Network
    class OpenStack
      class SecurityGroup < Fog::OpenStack::Model
        identity :id

        attribute :name
        attribute :description
        attribute :security_group_rules
        attribute :tenant_id

        def destroy
          requires :id
          service.delete_security_group(id)
          true
        end

        def security_group_rules
          Fog::Network::OpenStack::SecurityGroupRules.new(:service => service).load(attributes[:security_group_rules])
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          merge_attributes(service.create_security_group(attributes).body['security_group'])
          true
        end
      end
    end
  end
end
