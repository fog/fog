require 'fog/core/collection'
require 'fog/dns/models/dnsmadeeasy/zone'

module Fog
  module DNSMadeEasy
    class DNS

      class Zones < Fog::Collection

        model Fog::DNSMadeEasy::DNS::Zone

        def all
          clear
          data = connection.list_domains.body['list'].collect{|domain| {:id => domain}}
          load(data)
        end

        def get(zone_id)
          data = connection.get_domain(zone_id).body
          data.merge!(:id => data['name'])
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
