require 'fog/core/model'

module Fog
  module HP
    class LB

      class LoadBalancer < Fog::Model
        identity :id
        attribute :name
        attribute :protocol
        attribute :port
        attribute :algorithm
        attribute :status
        attribute :nodes
        attribute :virtualIps
        attribute :created_at, :aliases => 'created'
        attribute :updated_at , :aliases => 'updated'

        def destroy
          requires :id
          service.delete_load_balancer(id)
          true
        end

        def ready?
          self.status == 'ACTIVE'
        end

        def save
          identity ? update : create
        end

        private

        def create
          merge_attributes(service.create_load_balancer(name, nodes, attributes).body)
          true
        end

        def update
          requires :id
          merge_attributes(service.update_load_balancer(id, attributes).body)
          true
        end

      end
    end
  end
end
