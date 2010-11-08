require 'fog/core/collection'
require 'fog/brightbox/models/compute/image'

module Fog
  module Brightbox
    class Compute

      class Images < Fog::Collection

        model Fog::Brightbox::Compute::Image

        def all
          data = connection.list_images.body
          load(JSON.parse(data))
        end

        def get(identifier)
          response = connection.get_image(identifier)
          new(JSON.parse(response.body))
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
