require 'fog/core/collection'
require 'fog/ibm/models/compute/image'

module Fog
  module Compute
    class IBM
      class Images < Fog::Collection
        model Fog::Compute::IBM::Image

        def all
          load(service.list_images.body['images'])
        end

        def get(image_id)
          begin
            new(service.get_image(image_id).body)
          rescue Fog::Compute::IBM::NotFound
            nil
          end
        end
      end
    end
  end
end
