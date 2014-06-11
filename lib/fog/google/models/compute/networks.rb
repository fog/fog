require 'fog/core/collection'
require 'fog/google/models/compute/network'

module Fog
  module Compute
    class Google
      class Networks < Fog::Collection
        model Fog::Compute::Google::Network

        def all
          data = service.list_networks.body
          load(data['items'] || [])
        end

        def get(identity)
          if network = service.get_network(identity).body
            new(network)
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
