require 'fog/core/collection'
require 'fog/hp/models/lb/node'

module Fog
  module HP
    class LB
      class Nodes < Fog::Collection
        model Fog::HP::LB::Node

        def all
          data = connection.list_nodes.body['nodes']
          load(data)
        end

        def get(record_id)
          record = connection.get_node_details(record_id).body['node']
          new(record)
        rescue Fog::HP::LB::NotFound
          nil
        end

      end
    end
  end
end