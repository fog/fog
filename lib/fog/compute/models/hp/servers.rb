require 'fog/core/collection'
require 'fog/compute/models/hp/server'

module Fog
  module HP
    class Compute

      class Servers < Fog::Collection

        model Fog::HP::Compute::Server

        def all
          data = connection.list_servers_detail.body['servers']
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server.setup(:password => server.password)
          server
        end

        def get(server_id)
          if server = connection.get_server_details(server_id).body['server']
            new(server)
          end
        rescue Fog::HP::Compute::NotFound
          nil
        end

      end

    end
  end
end
