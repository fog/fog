require 'fog/core/collection'
require 'fog/dns/models/slicehost/zone'

module Fog
  module Slicehost
    class DNS

      class Zones < Fog::Collection

        model Fog::Slicehost::DNS::Zone

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
