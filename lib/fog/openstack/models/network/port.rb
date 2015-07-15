require 'fog/openstack/models/model'

module Fog
  module Network
    class OpenStack
      class Port < Fog::OpenStack::Model
        identity :id

        attribute :name
        attribute :network_id
        attribute :fixed_ips
        attribute :mac_address
        attribute :status
        attribute :admin_state_up
        attribute :device_owner
        attribute :device_id
        attribute :tenant_id
        attribute :security_groups

        def create
          requires :network_id
          merge_attributes(service.create_port(self.network_id,
                                                  self.attributes).body['port'])
          self
        end

        def update
          requires :id, :network_id
          merge_attributes(service.update_port(self.id,
                                                  self.attributes).body['port'])
          self
        end

        def destroy
          requires :id
          service.delete_port(self.id)
          true
        end
      end
    end
  end
end
