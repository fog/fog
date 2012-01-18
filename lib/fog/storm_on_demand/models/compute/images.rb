require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/image'

module Fog
  module Compute
    class StormOnDemand

      class Images < Fog::Collection

        model Fog::Compute::StormOnDemand::Image

        def all
          data = connection.list_images.body['items']
          load(data)
        end

      end

    end
  end
end
