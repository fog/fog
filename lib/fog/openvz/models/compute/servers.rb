require 'fog/core/collection'
require 'fog/openvz/models/compute/server'

module Fog
  module Compute
    class Openvz
      class Servers < Fog::Collection
        model Fog::Compute::Openvz::Server

        def all(filters = {})
          load service.list_servers
        end

        def get(id)
          if server = service.get_server_details(id)
            new server
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
