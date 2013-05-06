require 'fog/core/collection'
require 'fog/hp/models/compute_v2/image'

module Fog
  module Compute
    class HPV2

      class Images < Fog::Collection

        model Fog::Compute::HPV2::Image

        def all(options = {})
          data = service.list_images_detail(options).body['images']
          load(data)
          self
        end

        def get(image_id)
          data = service.get_image_details(image_id).body['image']
          new(data)
        rescue Fog::Compute::HPV2::NotFound
          nil
        end

      end

    end
  end
end
