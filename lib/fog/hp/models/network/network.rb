require 'fog/core/model'

module Fog
  module HP
    class Network

      class Network < Fog::Model
        identity :id

        attribute :name
        attribute :tenant_id
        attribute :status
        attribute :subnets
        attribute :shared
        attribute :admin_state_up
        attribute :router_external,    :aliases => 'router:external'

        def destroy
          requires :id
          service.delete_network(id)
          true
        end

        def save
          identity ? update : create
        end

        def create
          merge_attributes(service.create_network(attributes).body['network'])
          self
        end

        def update
          requires :id
          merge_attributes(service.update_network(id, attributes).body['network'])
          self
        end

      end
    end
  end
end
