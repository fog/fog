require 'fog/core/collection'
require 'fog/storm_on_demand/models/network/private_ip'

module Fog
  module Network
    class StormOnDemand

      class PrivateIps < Fog::Collection

        model Fog::Network::StormOnDemand::PrivateIp

        def all
          data = service.list_private_ips.body['networks']
          load(data)
        end

        def get(server_id)
          service.get_private_ip(:uniq_id => server_id).body['ip']
        end

        def attach(server_id)
          res = service.attach_server_to_private_ip(:uniq_id => server_id).body
          res['attached'].to_i == 1 ? true : false
        end

        def detach(server_id)
          r = service.detach_server_from_private_ip(:uniq_id => server_id).body
          r['detached'].to_i == 1 ? true : false
        end

        def attached?(server_id)
          r = service.check_server_attached(:uniq_id => server_id).body
          r['is_attached'].to_i == 1 ? true : false
        end
        
      end

    end
  end
end
