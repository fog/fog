require 'fog/core/collection'
require 'fog/rage4/models/dns/zone'

module Fog
  module DNS
    class Rage4

      class Zones < Fog::Collection

        model Fog::DNS::Rage4::Zone

        def all
          clear
          data = service.list_domains.body.map {|zone| zone['domain']}
          load(data)
        end

        def get(zone_id)
          data = service.get_domain(zone_id).body['domain']
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
