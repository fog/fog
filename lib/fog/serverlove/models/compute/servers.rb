require 'fog/core/collection'
require 'fog/serverlove/models/compute/drive'

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
          load(connection.get_drive(server_id).body)
        end

      end

    end
  end
end
