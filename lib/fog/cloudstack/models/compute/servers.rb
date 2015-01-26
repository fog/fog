require 'fog/core/collection'
require 'fog/cloudstack/models/compute/server'

module Fog
  module Compute
    class Cloudstack
      class Servers < Fog::Collection
        model Fog::Compute::Cloudstack::Server

        def all(attributes={})
          # add project id if we have one
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
          attributes = {'id' => server_id}
          # add project id if we have one
          servers = service.list_virtual_machines(attributes)["listvirtualmachinesresponse"]["virtualmachine"]
          if servers.nil? || servers.empty?
            servers = service.list_virtual_machines('id' => server_id, 'projectid' => '-1')["listvirtualmachinesresponse"]["virtualmachine"]
          end
          unless servers.nil? || servers.empty?
            new(servers.first)
          end
        rescue Fog::Compute::Cloudstack::BadRequest
          nil
        end
      end
    end
  end
end
