require 'fog/core/collection'
require 'fog/dns/models/bluebox/zone'

module Fog
  module Bluebox
    class DNS

      class Zones < Fog::Collection

        model Fog::Bluebox::DNS::Zone

        def all
          data = connection.get_zones.body['zones']
          load(data)
        end

        def get(zone_id)
          data = connection.get_zone(zone_id).body
          new(data)
        rescue Fog::Service::NotFound
          nil
        end

      end

    end
  end
end
