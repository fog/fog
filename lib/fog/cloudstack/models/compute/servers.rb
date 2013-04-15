require 'fog/core/collection'
require 'fog/cloudstack/models/compute/server'

module Fog
  module Compute
    class Cloudstack

      class Servers < Fog::Collection

        model Fog::Compute::Cloudstack::Server

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
          if server = service.list_virtual_machines('id' => server_id)["listvirtualmachinesresponse"]["virtualmachine"].first
            new(server)
          end
        rescue Fog::Compute::Cloudstack::BadRequest
          nil
        end
      end

    end
  end
end
