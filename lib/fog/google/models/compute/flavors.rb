require 'fog/core/collection'
require 'fog/google/models/compute/flavor'

module Fog
  module Compute
    class Google

      class Flavors < Fog::Collection

        model Fog::Compute::Google::Flavor

        def all
          zone = service.list_zones.body['items'].first
          data = connection.list_machine_types(zone['name']).body["items"]
          load(data)
        end

        def get(identity)
          data = connection.get_machine_type(identity).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
