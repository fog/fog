require 'fog/core/collection'
require 'fog/go_grid/models/compute/server'

module Fog
  module Compute
    class GoGrid

      class Servers < Fog::Collection

        model Fog::Compute::GoGrid::Server

        def all
          data = connection.grid_server_list.body['list']
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server.setup
          server
        end

        def get(server_id)
          if server_id && server = connection.grid_server_get(server_id).body['list'].first
            new(server)
          end
        rescue Fog::Compute::GoGrid::NotFound
          nil
        end

      end

    end
  end
end
