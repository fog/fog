require 'fog/core/model'

module Fog
  module Rackspace
    class LoadBalancers
      class Node < Fog::Model

        identity :id

        attribute :address
        attribute :status
        attribute :weight
        attribute :port
        attribute :condition

        def destroy
          requires :identity, :load_balancer
          connection.delete_node(load_balancer.identity, identity)
          true
        end

        def save
          if identity
            update
          else
            create
          end
          true
        end

        private
        def load_balancer
          collection.load_balancer
        end
        def create
          requires :load_balancer, :address, :condition, :port
          options = {}
          unless weight.nil?
            options[:weight] = weight
          end
          data = connection.create_node(load_balancer.id, address, port, condition, options)
          merge_attributes(data.body['nodes'][0])
        end

        def update
          requires :load_balancer, :identity
          options = {
            :condition => condition
          }
          unless weight.nil?
            options[:weight] = weight
          end
          connection.update_node(load_balancer.id, identity, options)
        end
      end
    end
  end
end
