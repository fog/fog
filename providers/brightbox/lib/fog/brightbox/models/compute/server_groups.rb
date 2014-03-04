require 'fog/core/collection'
require 'fog/brightbox/models/compute/server_group'

module Fog
  module Compute
    class Brightbox

      class ServerGroups < Fog::Collection

        model Fog::Compute::Brightbox::ServerGroup

        def all
          data = service.list_server_groups
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_server_group(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
