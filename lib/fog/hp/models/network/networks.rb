require 'fog/core/collection'
require 'fog/hp/models/network/network'

module Fog
  module HP
    class Network

      class Networks < Fog::Collection

        attribute :filters

        model Fog::HP::Network::Network

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          load(service.list_networks(filters).body['networks'])
        end

        def get(network_id)
          if network = service.get_network(network_id).body['network']
            new(network)
          end
        rescue Fog::HP::Network::NotFound
          nil
        end

      end
    end
  end
end
