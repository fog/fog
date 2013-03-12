require 'fog/core/collection'
require 'fog/google/models/compute/server'

module Fog
  module Compute
    class Google

      class Servers < Fog::Collection

        model Fog::Compute::Google::Server

        def all
          data = service.list_servers.body["items"] || []
          load(data)
        end

        def get(identity)
          data = service.get_server(identity).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

        def bootstrap(new_attributes = {})

          defaults = {
            :name => "fog-#{Time.now.to_i}",
            :image_name => "",
            :machine_type => "",
            :zone_name => "",
          }

          server = create(defaults.merge(new_attributes))
          server.wait_for { ready? }
          server
        end

      end

    end
  end
end
