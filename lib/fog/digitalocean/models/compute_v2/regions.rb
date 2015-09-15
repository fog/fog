module Fog
  module Compute
    class DigitalOceanV2
      class Regions < Fog::Collection
        model Fog::Compute::DigitalOceanV2::Region

        def all(filters = {})
          data = service.list_regions.body["regions"]
          load(data)
        end
      end
    end
  end
end