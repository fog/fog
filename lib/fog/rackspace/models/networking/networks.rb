require 'fog/rackspace/models/compute_v2/network'

module Fog
  module Rackspace
    class Networking
      class Networks < Fog::Collection
        model Fog::Rackspace::Networking::Network

        def all
          data = service.list_networks.body['networks']
          load(data)
        end

        def get(id)
          data = service.get_network(id).body['network']
          new(data)
        rescue Fog::Rackspace::Networking::NotFound
          nil
        end
      end
    end
  end
end
