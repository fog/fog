require 'fog/core/collection'
require 'fog/rackspace/models/node'

module Fog
  module Rackspace
    class LoadBalancer
      class Nodes < Fog::Collection
        model Fog::Rackspace::LoadBalancer::Node

        attr_accessor :load_balancer

        def all
          requires :load_balancer
          data = connection.list_nodes(load_balancer.id).body['nodes']
          load(data)
        end

        def get(node_id)
          requires :load_balancer
          if node = connection.get_node(load_balancer.id, node_id).body['node']
            new(node)
          end
        rescue Fog::Rackspace::LoadBalancer::NotFound
          nil
        end
      end
    end
  end
end
