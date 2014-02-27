require 'fog/core/collection'
require 'fog/brightbox/models/compute/image'

module Fog
  module Compute
    class Brightbox

      class Images < Fog::Collection

        model Fog::Compute::Brightbox::Image

        def all
          data = service.list_images
          load(data)
        end

        def get(identifier)
          data = service.get_image(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
