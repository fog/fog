require 'fog/core/collection'
require 'fog/compute/models/stormondemand/image'

module Fog
  module StormOnDemand
    class Compute

      class Images < Fog::Collection

        model Fog::StormOnDemand::Compute::Image

        def all
          data = connection.list_images.body['images']
          load(data)
        end

      end

    end
  end
end
