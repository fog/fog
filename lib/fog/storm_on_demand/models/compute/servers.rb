require 'fog/core/collection'
require 'fog/storm_on_demand/models/compute/server'

module Fog
  module Compute
    class StormOnDemand

      class Servers < Fog::Collection

        model Fog::Compute::StormOnDemand::Server

        def all
          data = service.list_servers.body['items']
          load(data)
        end

        def get(uniq_id)
          server = service.get_server(:uniq_id => uniq_id).body
          new(server)
        end

      end

    end
  end
end
