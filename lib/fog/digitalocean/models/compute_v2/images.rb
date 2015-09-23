module Fog
  module Compute
    class DigitalOceanV2
      class Images < Fog::Collection
        model Fog::Compute::DigitalOceanV2::Image

        def all(filters = {})
          data = service.list_images.body["images"]
          load(data)
        end
      end
    end
  end
end