require 'fog/core/collection'
require 'fog/bluebox/models/compute/location'

module Fog
  module Compute
    class Bluebox
      class Locations < Fog::Collection
        model Fog::Compute::Bluebox::Location

        def all
          data = service.get_locations.body
          load(data)
        end

        def get(location_id)
          response = service.get_location(location_id)
          new(response.body)
        rescue Fog::Compute::Bluebox::NotFound
          nil
        end
      end
    end
  end
end
