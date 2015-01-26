require 'fog/rackspace/models/networking_v2/network'

module Fog
  module Rackspace
    class NetworkingV2
      class Networks < Fog::Collection
        model Fog::Rackspace::NetworkingV2::Network

        def all
          data = service.list_networks.body['networks']
          load(data)
        end

        def get(id)
          data = service.show_network(id).body['network']
          new(data)
        rescue Fog::Rackspace::NetworkingV2::NotFound
          nil
        end
      end
    end
  end
end
