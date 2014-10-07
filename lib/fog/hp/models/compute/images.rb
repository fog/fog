require 'fog/core/collection'
require 'fog/hp/models/compute/image'

module Fog
  module Compute
    class HP
      class Images < Fog::Collection
        model Fog::Compute::HP::Image

        def all
          data = service.list_images_detail.body['images']
          load(data)
          self
        end

        def get(image_id)
          data = service.get_image_details(image_id).body['image']
          new(data)
        rescue Fog::Compute::HP::NotFound
          nil
        end
      end
    end
  end
end
