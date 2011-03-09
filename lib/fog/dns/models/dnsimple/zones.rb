require 'fog/core/collection'
require 'fog/dns/models/dnsimple/zone'

module Fog
  module DNSimple
    class DNS

      class Zones < Fog::Collection

        model Fog::DNSimple::DNS::Zone

        def all
          clear
          data = connection.list_domains.body
          data.each {|object| self << new(object["domain"]) }
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
