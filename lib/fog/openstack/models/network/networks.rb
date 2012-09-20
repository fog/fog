require 'fog/core/collection'
require 'fog/openstack/models/network/network'

module Fog
  module Network
    class OpenStack
      class Networks < Fog::Collection
        model Fog::Network::OpenStack::Network

        def all
          load(connection.list_networks.body['networks'])
        end

        def get(network_id)
          if network = connection.get_network(network_id).body['network']
            new(network)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end

      end
    end
  end
end