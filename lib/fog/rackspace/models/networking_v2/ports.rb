require 'fog/rackspace/models/networking_v2/port'

module Fog
  module Rackspace
    class NetworkingV2
      class Ports < Fog::Collection
        model Fog::Rackspace::NetworkingV2::Port

        def all
          data = service.list_ports.body['ports']
          load(data)
        end

        def get(id)
          data = service.show_port(id).body['port']
          new(data)
        rescue Fog::Rackspace::NetworkingV2::NotFound
          nil
        end
      end
    end
  end
end
