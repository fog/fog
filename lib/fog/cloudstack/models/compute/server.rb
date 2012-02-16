require 'fog/compute/models/server'

module Fog
  module Compute
    class Cloudstack

      class Server < Fog::Compute::Server
        extend Fog::Deprecation

        identity :id, :aliases => 'instanceId'

        attribute :name, :aliases => 'name'
        attribute :display_name, :aliases => 'displayName'
        attribute :flavor_id, :aliases => 'instanceType'
        attribute :image_id, :aliases => 'imageId'
        attribute :public_ip_address, :aliases => 'ipAddress'
        attribute :state, :aliases => 'instanceState'
        attribute :zone_id, :aliases => 'zone'
        attribute :key_name, :aliases => 'keyName'
        attribute :group_name, :aliases => 'groupName'

        def initialize(attributes={})
          super
        end

        def destroy
          requires :id

          connection.destroy_virtual_machine({'id' => id})

          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :image_id

          options = {
            'serviceOfferingId' => flavor_id,
            'templateId' => image_id,
            'zoneId' => zone_id,
            'name' => name,
            'keypair' => key_name,
            'group' => group_name
          }
          options.delete_if {|key, value| value.nil?}

          data = connection.deploy_virtual_machine(options).body
          self.id = data['id']

          true
        end

      end
    end
  end
end
