require 'fog/core/collection'
require 'fog/storm_on_demand/models/network/firewall'

module Fog
  module Network
    class StormOnDemand 
      class Firewalls < Fog::Collection
        model Fog::Network::StormOnDemand::Firewall

        def get(server_id)
          data = service.get_firewall(:uniq_id => server_id).body
          new(data)
        end

        def basic_options(server_id)
          res = service.get_firewall_basic_options(:uniq_id => server_id).body
          res['options']
        end

        def rules(server_id)
          service.get_firewall_rules(:uniq_id => server_id).body['rules']
        end

        def update(options)
          service.update_firewall(options)
          true
        end
        
      end
    end
  end
end
