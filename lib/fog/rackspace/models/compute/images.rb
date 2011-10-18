require 'fog/core/collection'
require 'fog/rackspace/models/compute/image'

module Fog
  module Compute
    class Rackspace

      class Images < Fog::Collection

        model Fog::Compute::Rackspace::Image

        attribute :server

        def all
          data = connection.list_images_detail.body['images']
          load(data)
          if server
            self.replace(self.select {|image| image.server_id == server.id})
          end
        end

        def get(image_id)
          data = connection.get_image_details(image_id).body['image']
          new(data)
        rescue Fog::Compute::Rackspace::NotFound
          nil
        end

      end

    end
  end
end
