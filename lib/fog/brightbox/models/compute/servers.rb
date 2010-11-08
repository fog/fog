require 'fog/core/collection'
require 'fog/brightbox/models/compute/server'

module Fog
  module Brightbox
    class Compute

      class Servers < Fog::Collection

        model Fog::Brightbox::Compute::Server

        def all
          data = JSON.parse(connection.list_servers.body)
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = JSON.parse(connection.get_server(identifier).body)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end