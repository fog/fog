require 'fog/core/collection'
require 'fog/openstack/models/network/port'

module Fog
  module Network
    class OpenStack
      class Ports < Fog::Collection
        model Fog::Network::OpenStack::Port

        def all
          load(connection.list_ports.body['ports'])
        end

        def get(port_id)
          if port = connection.get_port(port_id).body['port']
            new(port)
          end
        rescue Fog::Network::OpenStack::NotFound
          nil
        end

      end
    end
  end
end