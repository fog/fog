require 'fog/core/collection'
require 'fog/clodo/models/compute/image'

module Fog
  module Compute
    class Clodo

      class Images < Fog::Collection

        model Fog::Compute::Clodo::Image

        def all
          data = connection.list_images_detail.body['images']
          load(data)
        end

        def get(image_id)
          nil
        end

      end

    end
  end
end
