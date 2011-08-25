require 'fog/core/collection'
require 'fog/brightbox/models/compute/server'

module Fog
  module Compute
    class Brightbox

      class Servers < Fog::Collection

        model Fog::Compute::Brightbox::Server

        def all
          data = connection.list_servers
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = connection.get_server(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end