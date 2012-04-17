require 'fog/core/collection'
require 'fog/hp/models/compute/image'

module Fog
  module Compute
    class HP

      class Images < Fog::Collection

        model Fog::Compute::HP::Image

        attribute :server

        def all
          data = connection.list_images_detail.body['images']
          load(data)
          if server
            self.replace(self.select {|image| image.server.id == server.id})
          end
          self
        end

        def get(image_id)
          data = connection.get_image_details(image_id).body['image']
          new(data)
        rescue Fog::Compute::HP::NotFound
          nil
        end

      end

    end
  end
end
