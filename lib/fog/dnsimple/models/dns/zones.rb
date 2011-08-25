require 'fog/core/collection'
require 'fog/dnsimple/models/dns/zone'

module Fog
  module DNS
    class DNSimple

      class Zones < Fog::Collection

        model Fog::DNS::DNSimple::Zone

        def all
          clear
          data = connection.list_domains.body.map {|zone| zone['domain']}
          load(data)
        end

        def get(zone_id)
          data = connection.get_domain(zone_id).body['domain']
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
