require 'fog/core/collection'
require 'fog/storm_on_demand/models/dns/zone'

module Fog
  module DNS
    class StormOnDemand
      class Zones < Fog::Collection
        model Fog::DNS::StormOnDemand::Zone

        def create(options)
          zone = service.create_zone(options).body
          new(zone)
        end

        def get(zone_id)
          zone = service.get_zone(:id => zone_id).body
          new(zone)
        end

        def all(options={})
          zones = service.list_zones(options).body['items']
          load(zones)
        end
      end
    end
  end
end
