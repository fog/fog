require 'fog/core/collection'
require 'fog/voxel/models/compute/image'

module Fog
  module Compute
    class Voxel

      class Images < Fog::Collection

        model Fog::Compute::Voxel::Image

        def all
          data = service.images_list.body['images']
          load(data)
        end

        def get(image_id)
          data = service.images_list(image_id).body['images']

          if data.empty?
            nil
          else
            new(data.first)
          end
        end
      end

    end
  end
end
