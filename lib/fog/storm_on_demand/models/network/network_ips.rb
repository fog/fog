require 'fog/core/collection'
require 'fog/storm_on_demand/models/network/network_ip'

module Fog
  module Network
    class StormOnDemand
      class NetworkIPs < Fog::Collection
        model Fog::Network::StormOnDemand::NetworkIP

        def add(options)
          service.add_ip_to_server(options)
          true
        end

        def get(server_id, ip)
          data = service.get_ip_details(:uniq_id => server_id, :ip => ip).body
          new(data)
        end

        def all(options={})
          data = service.list_network_ips(options).body['items']
          load(data)
        end

        def get_public_accounts(options={})
          service.list_ip_public_accounts(options).body['items']
        end

        def all_public(options={})
          data = service.list_network_public_ips(options).body['items']
          load(data)
        end

        def remove(options)
          service.remove_ip_from_server(options)
          true
        end

        def request_new_ips(options)
          service.request_new_ips(options)
          true
        end
      end
    end
  end
end
