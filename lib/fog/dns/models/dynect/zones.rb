require 'fog/core/collection'
require 'fog/dns/models/dynect/zone'

module Fog
  module Dynect
    class DNS

      class Zones < Fog::Collection

        model Fog::Dynect::DNS::Zone

        def all
          zone_names = connection.list_zones.body["zones"]
          load(zone_names.map {|name|
                 {
                   "zone" => name
                 }
               })
        end

        def get(zone_id)
          new(connection.get_zone(zone_id).body)
        end

      end

    end
  end
end
