require 'fog/core/model'

module Fog
  module HP
    class Network
      class Router < Fog::Model
        identity :id

        attribute :name
        attribute :tenant_id
        attribute :external_gateway_info
        attribute :admin_state_up, :type => :boolean
        attribute :status

        def destroy
          requires :id
          service.delete_router(id)
          true
        end

        def add_interface(subnet_id=nil, port_id=nil, options={})
          requires :id
          begin
            service.add_router_interface(id, subnet_id, port_id, options).body['router']
            true
          rescue ArgumentError, Fog::HP::Network::NotFound
            false
          end
        end

        def remove_interface(subnet_id=nil, port_id=nil, options={})
          requires :id
          begin
            service.remove_router_interface(id, subnet_id, port_id, options)
            true
          rescue ArgumentError, Fog::HP::Network::NotFound
            false
          end
        end

        def ready?
          self.status == 'ACTIVE'
        end

        def save
          identity ? update : create
        end

        private

        def create
          merge_attributes(service.create_router(attributes).body['router'])
          true
        end

        def update
          requires :id
          merge_attributes(service.update_router(id, attributes).body['router'])
          true
        end
      end
    end
  end
end
