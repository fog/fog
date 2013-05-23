require "fog/core/collection"
require "fog/storm_on_demand/models/compute/zone"

module Fog
  module Compute
    class StormOnDemand

      class Zones < Fog::Collection
        model Fog::Compute::StormOnDemand::Zone

        def get(zone_id)
          z = service.get_zone(:id => zone_id).body
          new(z)
        end

        def all(options={})
          data = service.list_zones(options).body
          load(data)
        end
        
      end
    end
  end
end
