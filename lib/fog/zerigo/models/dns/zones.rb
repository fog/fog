require 'fog/core/collection'
require 'fog/zerigo/models/dns/zone'

module Fog
  module DNS
    class Zerigo

      class Zones < Fog::Collection

        model Fog::DNS::Zerigo::Zone

        def all
          data = connection.list_zones.body['zones']
          load(data)
        end

        def get(zone_id)
          data = connection.get_zone(zone_id).body
          zone = new(data)
          zone.records.load(data['hosts'])
          zone
        rescue Fog::Service::NotFound
          nil
        end

      end

    end
  end
end
