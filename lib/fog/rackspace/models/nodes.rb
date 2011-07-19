require 'fog/core/collection'
require 'fog/rackspace/models/node'

module Fog
  module Rackspace
    class LoadBalancer
      class Nodes < Fog::Collection
        model Fog::Rackspace::LoadBalancer::Node

        attr_accessor :load_balancer

        def all
          data = connection.list_nodes(load_balancer.id).body['nodes']
          load(data)
        end

        def get(node_id)
          if node = connection.get_node(load_balancer.id, node_id).body['node']
            new(node)
          end
        rescue Fog::Rackspace::LoadBalancer::NotFound
          nil
        end

        def to_object
          collect do |node|
            node.to_object
          end
        end
      end
    end
  end
end
