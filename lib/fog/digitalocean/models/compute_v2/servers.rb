require 'fog/core/collection'
require 'fog/digitalocean/models/compute/server'

module Fog
  module Compute
    class DigitalOceanV2
      class Servers < Fog::Collection
        model Fog::Compute::DigitalOceanV2::Server

        # Returns list of servers
        def all(filters = {})
          data = service.list_servers.body['droplets']
          load(data)
        end

        # Retrieves server
        def get(id)
          server = service.get_server_details(id).body['droplet']
          new(server) if server
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
