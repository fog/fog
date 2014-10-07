require 'fog/core/model'

module Fog
  module HP
    class Network
      class Network < Fog::Model
        identity :id

        attribute :name
        attribute :tenant_id
        attribute :status
        attribute :shared
        attribute :admin_state_up
        attribute :router_external,    :aliases => 'router:external'

        def destroy
          requires :id
          service.delete_network(id)
          true
        end

        def ready?
          self.status == 'ACTIVE'
        end

        def subnets
          @subnets ||= begin
            Fog::HP::Network::Subnets.new({
              :service => service,
              :filters => {:network_id => self.id}
            })
          end
        end

        def save
          identity ? update : create
        end

        private

        def create
          merge_attributes(service.create_network(attributes).body['network'])
          true
        end

        def update
          requires :id
          merge_attributes(service.update_network(id, attributes).body['network'])
          true
        end
      end
    end
  end
end
