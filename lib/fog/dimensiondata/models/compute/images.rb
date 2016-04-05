require 'fog/core/collection'
require 'fog/dimensiondata/models/compute/image'

module Fog
  module Compute
    class DimensionData
      class Images < Fog::Collection
        model Fog::Compute::DimensionData::Image

        def all
          load(service.list_images.body)
        end

        def get(id)
          data = service.get_image(id).body
          new(data)
        end
      end # Images
    end # DimensionData
  end # Compute
end # Fog
