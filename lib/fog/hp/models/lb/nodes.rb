require 'fog/core/collection'
require 'fog/hp/models/lb/node'

module Fog
  module HP
    class LB
      class Nodes < Fog::Collection
        model Fog::HP::LB::Node

        attr_accessor :load_balancer

        def all
          requires :load_balancer
          data = service.list_load_balancer_nodes(load_balancer.id).body['nodes']
          load(data)
        end

        def get(node_id)
          requires :load_balancer
          node = service.get_load_balancer_node(load_balancer.id, node_id).body
          new(node)
        rescue Fog::HP::LB::NotFound
          nil
        end
      end
    end
  end
end
