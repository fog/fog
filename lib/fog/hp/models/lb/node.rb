require 'fog/core/model'

module Fog
  module HP
    class LB
      class Node < Fog::Model
        identity  :id

        attribute :address
        attribute :port
        attribute :condition
        attribute :status

        def destroy
          requires :id, :load_balancer
          service.delete_load_balancer_node(load_balancer.id, id)
          true
        end

        def ready?
          self.status == 'ONLINE'
        end

        def save
          identity ? update : create
        end

        private

        def load_balancer
          collection.load_balancer
        end

        def create
          requires :load_balancer, :address, :port
          options = {}
          options['condition'] = condition if condition
          data = service.create_load_balancer_node(load_balancer.id, address, port, options)
          merge_attributes(data.body['nodes'][0])
          true
        end

        def update
          requires :id, :load_balancer, :condition
          service.update_load_balancer_node(load_balancer.id, id, condition)
          true
        end
      end
    end
  end
end
