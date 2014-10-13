require 'fog/core/collection'
require 'fog/fogdocker/models/compute/image'

module Fog
  module Compute
    class Fogdocker
      class Images < Fog::Collection
        model Fog::Compute::Fogdocker::Image

        def all(filters = {})
          load service.image_all(filters)
        end

        def get(id)
          new service.image_get(id)
        end

        def image_search(query = {})
          service.image_search(query)
        end
      end
    end
  end
end
