require "fog/core/collection"
require "fog/storm_on_demand/models/network/zone"

module Fog
  module Network
    class StormOnDemand

      class Zones < Fog::Collection
        model Fog::Network::StormOnDemand::Zone

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
