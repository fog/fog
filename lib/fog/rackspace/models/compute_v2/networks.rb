require 'fog/rackspace/models/compute_v2/network'

module Fog
  module Compute
    class RackspaceV2
      class Networks < Fog::Collection
        model Fog::Compute::RackspaceV2::Network

        def all
          data = service.list_networks.body['networks']
          load(data)
        end

        def get(id)
          data = service.get_network(id).body['network']
          new(data)
        rescue Fog::Compute::RackspaceV2::NotFound
          nil
        end
      end
    end
  end
end
