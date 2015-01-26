require 'fog/core/collection'
require 'fog/dreamhost/models/dns/zone'

module Fog
  module DNS
    class Dreamhost
      #
      # Dreamhost API has no concept of 'Zone', but we
      # can emulate it.
      #
      # http://wiki.dreamhost.com/API/Dns_commands
      #
      class Zones < Fog::Collection
        model Fog::DNS::Dreamhost::Zone

        def all
          clear
          zones = []
          zones_added = []
          service.records.each do |r|
            unless zones_added.include?(r.zone)
              zones << { :id => r.zone, :domain => r.zone }
              zones_added << r.zone
            end
          end
          load(zones)
        end

        def get(zone_id)
          service.zones.find { |z| z.domain == zone_id }
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
