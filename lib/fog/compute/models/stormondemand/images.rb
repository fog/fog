require 'fog/core/collection'
require 'fog/compute/models/stormondemand/image'

module Fog
  module Stormondemand
    class Compute

      class Images < Fog::Collection

        model Fog::Stormondemand::Compute::Image

        def all
          data = connection.list_images.body['images']
          load(data)
        end

      end

    end
  end
end
