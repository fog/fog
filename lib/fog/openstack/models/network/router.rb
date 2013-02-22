require 'fog/core/model'

module Fog
  module Network
    class OpenStack
      class Router < Fog::Model
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
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)
          super
        end

        def save
          requires :name
          identity ? update : create
        end

        def create
          requires :name
          merge_attributes(service.create_router(self.name,
                                                  self.attributes).body['router'])
          self
        end

        def update
          requires :id
          merge_attributes(service.update_router(self.id,
                                                  self.attributes).body['router'])
          self
        end

        def destroy
          requires :id
          service.delete_router(self.id)
          true
        end

      end
    end
  end
end
