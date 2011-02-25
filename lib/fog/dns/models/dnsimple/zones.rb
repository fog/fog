require 'fog/core/collection'
require 'fog/dns/models/dnsimple/zone'

module Fog
  module DNSimple
    class DNS

      class Zones < Fog::Collection

        model Fog::DNSimple::DNS::Zone

        def all
          data = connection.list_domains.body
          load(data)
        end

        def get(zone_id)
          data = connection.get_domain(zone_id).body["domain"]
          zone = new(data)
          zone.records.load(data["record"])
          zone
        rescue Fog::Service::NotFound
          nil
        end

      end

    end
  end
end
