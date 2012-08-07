require 'fog/core/collection'
require 'fog/rackspace/models/compute_v2/server'

module Fog
  module Compute
    class RackspaceV2
      class Servers < Fog::Collection

        model Fog::Compute::RackspaceV2::Server

        def all
          data = connection.list_servers.body['servers']
          load(data)
        end

        def get(server_id)
          data = connection.get_server(server_id).body['server']
          new(data)
        rescue Fog::Compute::RackspaceV2::NotFound
          nil
        end
      end
    end
  end
end
