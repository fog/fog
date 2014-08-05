require 'fog/core/collection'
require 'fog/bluebox/models/dns/zone'

module Fog
  module DNS
    class Bluebox
      class Zones < Fog::Collection
        model Fog::DNS::Bluebox::Zone

        def all
          data = service.get_zones.body['zones']
          load(data)
        end

        def get(zone_id)
          data = service.get_zone(zone_id).body
          new(data)
        rescue Fog::Service::NotFound
          nil
        end
      end
    end
  end
end
