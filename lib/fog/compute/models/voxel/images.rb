require 'fog/core/collection'
require 'fog/compute/models/voxel/image'

module Fog
  module Voxel
    class Compute

      class Images < Fog::Collection

        model Fog::Voxel::Compute::Image

        def all
          data = connection.images_list
          load(data)
        end

        def get(image_id)
          data = connection.images_list(image_id)
          
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
