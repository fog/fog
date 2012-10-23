require 'fog/core/collection'
require 'fog/gce/models/compute/server'

module Fog
  module Compute
    class GCE

      class Servers < Fog::Collection

        model Fog::Compute::GCE::Server

        def all
          data = connection.list_servers.body["items"]
          load(data)
        end

        def get(identity)
          data = connection.get_server(identity).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
