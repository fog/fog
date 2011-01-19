require 'fog/core/collection'
require 'fog/compute/models/voxel/image'

module Fog
  module Voxel
    class Compute

      class Images < Fog::Collection

        model Fog::Voxel::Compute::Image

        def all
          data = connection.list_images.body['images']
          load(data)
        end

        def get(image_id)
          data = connection.list_images(image_id).body['image']
          new(data)
        rescue Fog::Voxel::Compute::NotFound
          nil
        end

      end

    end
  end
end
