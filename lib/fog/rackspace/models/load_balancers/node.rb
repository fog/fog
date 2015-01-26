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
        attribute :type
        attribute :condition

        def destroy
          requires :identity, :load_balancer
          service.delete_node(load_balancer.identity, identity)
          true
        end

        def save
          if persisted?
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
          unless type.nil?
            options[:type] = type
          end
          data = service.create_node(load_balancer.id, address, port, condition, options)
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
          unless type.nil?
            options[:type] = type
          end
          service.update_node(load_balancer.id, identity, options)
        end
      end
    end
  end
end
