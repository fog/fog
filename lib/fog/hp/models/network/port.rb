require 'fog/core/model'

module Fog
  module HP
    class Network
      class Port < Fog::Model
        identity :id

        attribute :name
        attribute :network_id
        attribute :tenant_id
        attribute :fixed_ips
        attribute :mac_address
        attribute :status
        attribute :admin_state_up
        attribute :device_id
        attribute :device_owner
        attribute :security_groups

        def destroy
          requires :id
          service.delete_port(id)
          true
        end

        def ready?
          self.status == 'ACTIVE'
        end

        def save
          requires :network_id
          identity ? update : create
        end

        private

        def create
          requires :network_id
          merge_attributes(service.create_port(network_id, attributes).body['port'])
          true
        end

        def update
          requires :id, :network_id
          merge_attributes(service.update_port(id, attributes).body['port'])
          true
        end
      end
    end
  end
end
