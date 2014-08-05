require 'fog/core/collection'
require 'fog/ninefold/models/compute/flavor'

module Fog
  module Compute
    class Ninefold
      class Flavors < Fog::Collection
        model Fog::Compute::Ninefold::Flavor

        def all
          data = service.list_service_offerings
          load(data)
        end

        def get(identifier)
          data = service.list_service_offerings(:id => identifier)
          if data.empty?
            nil
          else
            new(data[0])
          end
        end
      end
    end
  end
end
