require 'fog/core/collection'
require 'fog/brightbox/models/compute/database_server'

module Fog
  module Compute
    class Brightbox

      class DatabaseServers < Fog::Collection

        model Fog::Compute::Brightbox::DatabaseServer

        def all
          data = service.list_database_servers
          load(data)
        end

        def get(identifier)
          data = service.get_database_server(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
