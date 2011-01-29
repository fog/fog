require 'fog/core/collection'
require 'fog/compute/models/go_grid/server'

module Fog
  module GoGrid
    class Compute

      class Servers < Fog::Collection

        model Fog::GoGrid::Compute::Server

        def all
          data = connection.grid_server_list.body['list']
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server
        end

        def get(server_id)
          if server_id && server = connection.grid_server_get(server_id).body['list'].first
            new(server)
          end
        rescue Fog::GoGrid::Compute::NotFound
          nil
        end

      end

    end
  end
end
