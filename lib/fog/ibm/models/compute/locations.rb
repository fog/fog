require 'fog/core/collection'
require 'fog/ibm/models/compute/location'

module Fog
  module Compute
    class IBM

      class Locations < Fog::Collection

        model Fog::Compute::IBM::Location

        def all
          load(connection.list_locations.body['locations'])
        end

        def get(location_id)
          begin
            new(connection.get_location(location_id).body)
          rescue Fog::Compute::IBM::NotFound
            nil
          end
        end

      end
    end
  end
end
