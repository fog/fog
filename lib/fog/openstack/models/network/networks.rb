require 'fog/core/collection'
require 'fog/openstack/models/network/network'

module Fog
  module Network
    class OpenStack
      class Networks < Fog::Collection
        attribute :filters

        model Fog::Network::OpenStack::Network

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          filters = filters_arg
          load(service.list_networks(filters).body['networks'])
        end

        def get(network_id)
          if network = service.get_network(network_id).body['network']
            new(network)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
