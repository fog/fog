require 'fog/core/collection'
require 'fog/storm_on_demand/models/vpn/vpn'

module Fog
  module VPN
    class StormOnDemand
      class Vpns < Fog::Collection
        model Fog::VPN::StormOnDemand::Vpn

        def create(options)
          vpn = service.create_vpn(options).body
          new(vpn)
        end

        def get(uniq_id)
          vpn = service.get_vpn(:uniq_id => uniq_id).body
          new(vpn)
        end

        def all_users(options={})
          service.list_vpn_users(options).body['items']
        end

      end
    end
  end
end
