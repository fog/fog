require 'fog/core/collection'
require 'fog/serverlove/models/compute/server'

module Fog
  module Compute
    class Serverlove

      class Servers < Fog::Collection

        model Fog::Compute::Serverlove::Server

        def all
          data = connection.get_servers.body
          load(data)
        end

        def get(server_id)
          data = connection.get_server(server_id).body
          new(data)
        end

      end

    end
  end
end
