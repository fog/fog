module Fog
  module Compute
    class DigitalOceanV2
      class Flavors < Fog::Collection
        model Fog::Compute::DigitalOceanV2::Flavor

        def all(filters = {})
          data = service.list_flavors.body["sizes"]
          load(data)
        end
      end
    end
  end
end