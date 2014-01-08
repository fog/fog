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

          check_keys(new_attributes)

          credential = Fog.respond_to?(:credential) && Fog.credential || :default
          name       = "fog_#{credential}"
          ssh_key    = service.ssh_keys.detect { |key| key.name == name }
          if ssh_key.nil?
            ssh_key = service.ssh_keys.create(
              :name        => name,
              :ssh_pub_key => (new_attributes[:public_key] || File.read(new_attributes[:public_key_path]))
            )
          end
          server.ssh_keys = [ssh_key]

          server.save
          server.wait_for { ready? }

          if new_attributes[:private_key]
            server.setup :key_data => [new_attributes[:private_key]]
          else
            server.setup :keys => [new_attributes[:private_key_path]]
          end

          server
        end

        def get(id)
          server = service.get_server_details(id).body['droplet']
          new(server) if server
        rescue Fog::Errors::NotFound
          nil
        end

        protected

        def check_keys(attributes)
          check_key :public, attributes[:public_key], attributes[:public_key_path]
          check_key :private, attributes[:private_key], attributes[:private_key_path]
        end

        def check_key(name, data, path)
          if [data, path].all?(&:nil?)
            raise ArgumentError, "either #{name}_key or #{name}_key_path is required to configure the server"
          end
        end

      end

    end
  end
end
