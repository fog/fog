require 'fog/dimensiondata/models/compute/network'
module Fog
  module Compute
    class DimensionData
      class Networks < Fog::Collection
        model Fog::Compute::DimensionData::Network

        def all
          load(service.list_networks.body)
        end
      end
    end
  end
end
