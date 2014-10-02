require 'fog/core/collection'
require 'fog/profitbricks/models/compute/server'

module Fog
    module Compute
        class ProfitBricks
            class Servers < Fog::Collection
                model Fog::Compute::ProfitBricks::Server

                def all
                    load (service.get_all_servers.body['getAllServersResponse'])
                end

                def get(id)
                    server = service.get_server(id).body['getServerResponse']
                    new(server)
                rescue Excon::Errors::NotFound
                    nil
                end
            end
        end
    end
end