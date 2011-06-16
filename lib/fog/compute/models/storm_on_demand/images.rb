require 'fog/core/collection'
require 'fog/compute/models/storm_on_demand/image'

module Fog
  module Compute
    class StormOnDemand

      class Images < Fog::Collection

        model Fog::Compute::StormOnDemand::Image

        def all
          data = connection.list_images.body['images']
          load(data)
        end

      end

    end
  end
end
