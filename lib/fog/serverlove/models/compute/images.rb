require 'fog/core/collection'
require 'fog/serverlove/models/compute/image'

module Fog
  module Compute
    class Serverlove

      class Images < Fog::Collection

        model Fog::Compute::Serverlove::Image

        def all
          data = connection.get_images.body
          load(data)
        end

        def get(image_id)
          connection.get_image(image_id)
        end

      end

    end
  end
end
