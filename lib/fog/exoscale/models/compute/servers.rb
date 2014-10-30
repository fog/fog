require 'fog/core/collection'
require 'fog/exoscale/models/compute/server'

module Fog
  module Compute
    class Exoscale
      class Servers < Fog::Collection
        model Fog::Compute::Exoscale::Server

        def all(attributes={})
          response = service.list_virtual_machines(attributes)
          data = response["listvirtualmachinesresponse"]["virtualmachine"] || []
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server
        end

        def get(server_id)
          servers = service.list_virtual_machines('id' => server_id)["listvirtualmachinesresponse"]["virtualmachine"]
          if servers.nil? || servers.empty?
            servers = service.list_virtual_machines('id' => server_id, 'projectid' => '-1')["listvirtualmachinesresponse"]["virtualmachine"]
          end
          unless servers.nil? || servers.empty?
            new(servers.first)
          end
        rescue Fog::Compute::Exoscale::BadRequest
          nil
        end
      end
    end
  end
end
