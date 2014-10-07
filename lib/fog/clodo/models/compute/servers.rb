require 'fog/core/collection'
require 'fog/clodo/models/compute/server'

module Fog
  module Compute
    class Clodo
      class Servers < Fog::Collection
        model Fog::Compute::Clodo::Server

        def all
          data = service.list_servers_detail.body['servers']
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server.setup(:password => server.password)
          server
        end

        def get(server_id)
          if server = service.get_server_details(server_id).body['server']
            new(server)
          end
        rescue Fog::Compute::Clodo::NotFound
          nil
        end
      end
    end
  end
end
