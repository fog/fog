require 'fog/openstack/models/model'

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
      class Router < Fog::OpenStack::Model
        identity :id

        attribute :name
        attribute :admin_state_up
        attribute :tenant_id
        attribute :external_gateway_info
        attribute :status

        def create
          requires :name

          response = service.create_router(self.name, options)
          merge_attributes(response.body['router'])

          self
        end

        def update
          requires :id
          response = service.update_router(self.id, options)
          merge_attributes(response.body['router'])
          self
        end

        def destroy
          requires :id
          service.delete_router(self.id)
          true
        end

        private

        def options
          options = self.attributes.dup

          if options[:external_gateway_info]
            if options[:external_gateway_info].is_a?(Fog::Network::OpenStack::Network)
               options[:external_gateway_info] = { :network_id => options[:external_gateway_info].id }
            else
              options[:external_gateway_info] = { :network_id => options[:external_gateway_info]}
            end
          end
          options
        end
      end
    end
  end
end
