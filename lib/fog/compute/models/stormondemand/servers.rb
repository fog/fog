require 'fog/core/collection'
require 'fog/compute/models/stormondemand/server'

module Fog
  module Stormondemand
    class Compute

      class Servers < Fog::Collection

        model Fog::Stormondemand::Compute::Server

        def all
          data = connection.list_servers.body['servers']
          load(data)
        end

        def get(uniq_id)
          server = connection.get_server(:uniq_id => uniq_id).body
          new(server)
        end

      end

    end
  end
end
