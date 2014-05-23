require 'fog/core/collection'
require 'fog/dnsmadeeasy/models/dns/zone'

module Fog
  module DNS
    class DNSMadeEasy
      class Zones < Fog::Collection
        model Fog::DNS::DNSMadeEasy::Zone

        def all
          clear
          data = service.list_domains.body['list'].map{|domain| {:id => domain}}
          load(data)
        end

        def get(zone_id)
          data = service.get_domain(zone_id).body
          data.merge!(:id => data['name'])
          new(data)
        rescue Fog::Service::NotFound
          nil
        end
      end
    end
  end
end
