require 'fog/core/collection'
require 'fog/slicehost/models/compute/server'

module Fog
  module Compute
    class Slicehost

      class Servers < Fog::Collection

        model Fog::Compute::Slicehost::Server

        def all
          data = connection.get_slices.body['slices']
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server.setup(:password => server.password)
          server
        end

        def get(server_id)
          if server_id && server = connection.get_slice(server_id).body
            new(server)
          elsif !server_id
            nil
          end
        rescue Excon::Errors::Forbidden
          nil
        end

      end

    end
  end
end
