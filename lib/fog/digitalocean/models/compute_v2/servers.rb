require 'fog/core/collection'
require 'fog/digitalocean/models/compute/server'

module Fog
  module Compute
    class DigitalOceanV2
      class Servers < Fog::Collection
        model Fog::Compute::DigitalOceanV2::Server

        # Returns list of servers
        # @return [Fog::Compute::DigitalOceanV2::Servers]
        # @raise [Fog::Compute::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#droplets
        def all(filters = {})
          data = service.list_servers.body['droplets']
          load(data)
        end

        # Retrieves server
        # @param [String] id for server to be returned
        # @return [Fog::Compute::DigitalOceanV2:Server]
        # @raise [Fog::Compute::DigitalOceanV2::NotFound] - HTTP 404
        # @raise [Fog::Compute::DigitalOceanV2::BadRequest] - HTTP 400
        # @raise [Fog::Compute::DigitalOceanV2::InternalServerError] - HTTP 500
        # @raise [Fog::Compute::DigitalOceanV2::ServiceError]
        # @see https://developers.digitalocean.com/documentation/v2/#retrieve-an-existing-droplet-by-id
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
