require 'fog/core/collection'
require 'fog/go_grid/models/compute/image'

module Fog
  module Compute
    class GoGrid

      class Images < Fog::Collection

        model Fog::Compute::GoGrid::Image

        attribute :server

        def all
          data = connection.grid_image_list.body['list']
          load(data)
          if server
            self.replace(self.select {|image| image.server_id == server.id})
          end
        end

        def get(image_id)
          response = connection.grid_image_get.body['list'][image_id]
          new(data)
        rescue Fog::Compute::GoGrid::NotFound
          nil
        end

      end

    end
  end
end
