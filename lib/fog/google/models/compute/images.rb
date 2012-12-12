require 'fog/core/collection'
require 'fog/google/models/compute/image'

module Fog
  module Compute
    class Google

      class Images < Fog::Collection

        model Fog::Compute::Google::Image

        def all
          data = connection.list_images.body["items"]
          load(data)
        end

        def get(identity)
          data = connection.get_image(identity).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
