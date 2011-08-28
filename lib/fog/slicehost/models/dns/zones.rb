require 'fog/core/collection'
require 'fog/slicehost/models/dns/zone'

module Fog
  module DNS
    class Slicehost

      class Zones < Fog::Collection

        model Fog::DNS::Slicehost::Zone

        def all
          data = connection.get_zones.body['zones']
          load(data)
        end

        def get(zone_id)
          data = connection.get_zone(zone_id).body
          new(data)
        rescue Excon::Errors::Forbidden
          nil
        end

      end

    end
  end
end
