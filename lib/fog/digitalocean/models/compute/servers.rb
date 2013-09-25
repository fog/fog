require 'fog/core/collection'
require 'fog/digitalocean/models/compute/server'

module Fog
  module Compute
    class DigitalOcean

      class Servers < Fog::Collection

        model Fog::Compute::DigitalOcean::Server

        def all(filters = {})
          data = service.list_servers.body['droplets']
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = new(new_attributes)

          raise(ArgumentError, "public_key_path is required to configure the server.") unless new_attributes[:public_key_path]
          raise(ArgumentError, "private_key_path is required to configure the server.") unless new_attributes[:private_key_path]
          credential = Fog.respond_to?(:credential) && Fog.credential || :default
          name       = "fog_#{credential}"
          ssh_key    = service.ssh_keys.detect { |key| key.name == name }
          if ssh_key.nil?
            ssh_key = service.ssh_keys.create(
              :name        => name,
              :ssh_pub_key => File.read(new_attributes[:public_key_path])
            )
          end
          server.ssh_keys = [ssh_key]

          server.save
          server.wait_for { ready? }
          server.setup :keys => [new_attributes[:private_key_path]]
          server
        end

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
