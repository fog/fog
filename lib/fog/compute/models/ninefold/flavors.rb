require 'fog/core/collection'
require 'fog/compute/models/ninefold/flavor'

module Fog
  module Ninefold
    class Compute

      class Flavors < Fog::Collection

        model Fog::Ninefold::Compute::Flavor

        def all
          data = connection.list_service_offerings
          load(data)
        end

        def get(identifier)
          data = connection.list_service_offerings(:id => identifier)
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
