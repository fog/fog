require 'fog/core/collection'
require 'fog/digitalocean/models/compute/server'

module Fog
  module Compute
    class DigitalOcean

      class Servers < Fog::Collection
        model Fog::Compute::DigitalOcean::Server

        def all(filters = {})
          load service.list_servers.body['droplets']
        end

        def get(id)
          if server = service.get_server_details(id).body['droplet']
            new server
          end
        rescue Fog::Errors::NotFound
          nil
        end

      end

    end
  end
end
