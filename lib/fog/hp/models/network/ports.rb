require 'fog/core/collection'
require 'fog/hp/models/network/port'

module Fog
  module HP
    class Network
      class Ports < Fog::Collection
        attribute :filters

        model Fog::HP::Network::Port

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters_arg = filters)
          filters = filters_arg
          non_aliased_filters = Fog::HP.convert_aliased_attributes_to_original(self.model, filters)
          load(service.list_ports(non_aliased_filters).body['ports'])
        end

        def get(port_id)
          if port = service.get_port(port_id).body['port']
            new(port)
          end
        rescue Fog::HP::Network::NotFound
          nil
        end
      end
    end
  end
end
