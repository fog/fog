require 'fog/core/model'

module Fog
  module Network
    class OpenStack
      class Port < Fog::Model
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

        def initialize(attributes)
          @connection = attributes[:connection]
          super
        end

        def save
          requires :network_id
          identity ? update : create
        end

        def create
          requires :network_id
          merge_attributes(connection.create_port(self.network_id,
                                                  self.attributes).body['port'])
          self
        end

        def update
          requires :id, :network_id
          merge_attributes(connection.update_port(self.id,
                                                  self.attributes).body['port'])
          self
        end

        def destroy
          requires :id
          connection.delete_port(self.id)
          true
        end

      end
    end
  end
end