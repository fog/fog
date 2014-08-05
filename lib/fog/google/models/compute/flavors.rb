require 'fog/core/collection'
require 'fog/google/models/compute/flavor'

module Fog
  module Compute
    class Google
      class Flavors < Fog::Collection
        model Fog::Compute::Google::Flavor

        def all(filters = {})
          if filters[:zone]
            data = service.list_machine_types(filters[:zone]).body["items"]
          else
            data = []
            service.list_aggregated_machine_types.body['items'].each_value do |zone|
              data.concat(zone['machineTypes']) if zone['machineTypes']
            end
          end
          load(data)
        end

        def get(identity, zone_name = nil)
          data = service.get_machine_type(identity, zone_name).body
          new(data)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
