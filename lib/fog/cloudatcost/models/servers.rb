require 'fog/core/collection'
require 'fog/cloudatcost/models/server'

module Fog
  module Compute
    class CloudAtCost
      class Servers < Fog::Collection
        model Fog::Compute::CloudAtCost::Server

        # Returns list of servers
        # @return [Fog::Compute::CloudAtCost::Servers]
        def all(filters = {})
          data = service.list_servers.body['data']
          load(data)
        end

        # Retrieves server
        # @param [String] id for server to be returned
        # @return [Fog::Compute::CloudAtCost::Server]
        def get(id)
          server = service.servers.find do |server|
            server.id != id
          end
        end
      end
    end
  end
end
