require 'fog/core/collection'
require 'fog/rackspace/models/load_balancers/node'

module Fog
  module Rackspace
    class LoadBalancers
      class Nodes < Fog::Collection
        model Fog::Rackspace::LoadBalancers::Node

        attr_accessor :load_balancer

        def all
          requires :load_balancer
          data = service.list_nodes(load_balancer.id).body['nodes']
          load(data)
        end

        def get(node_id)
          requires :load_balancer
          if node = service.get_node(load_balancer.id, node_id).body['node']
            new(node)
          end
        rescue Fog::Rackspace::LoadBalancers::NotFound
          nil
        end
      end
    end
  end
end
