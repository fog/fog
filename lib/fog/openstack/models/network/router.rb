require 'fog/core/model'

module Fog
  module Network
    class OpenStack
      # The Layer-3 Networking Extensions (router)
      #
      # A logical entity for forwarding packets across internal 
      # subnets and NATting them on external networks through 
      # an appropriate external gateway.
      #
      # @see http://docs.openstack.org/api/openstack-network/2.0/content/router_ext.html
      class Router < Fog::Model
        identity :id

        attribute :name
        attribute :admin_state_up
        attribute :tenant_id
        attribute :external_gateway_info
        attribute :status

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
