require 'fog/core/collection'
require 'fog/openstack/models/network/port'

module Fog
  module Network
    class OpenStack
      class Ports < Fog::Collection
        attribute :filters

        model Fog::Network::OpenStack::Port

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          load(service.list_ports(filters).body['ports'])
        end

        def get(port_id)
          if port = service.get_port(port_id).body['port']
            new(port)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end
      end
    end
  end
end
