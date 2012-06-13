require 'fog/core/collection'
require 'fog/cloudstack/models/compute/server'

module Fog
  module Compute
    class Cloudstack

      class Servers < Fog::Collection

        model Fog::Compute::Cloudstack::Server

        def all
          data = connection.list_virtual_machines["listvirtualmachinesresponse"]["virtualmachine"] || []
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server
        end

        def get(server_id)
          if server = connection.list_virtual_machines('id' => server_id)["listvirtualmachinesresponse"]["virtualmachine"].first
            new(server)
          end
        rescue Fog::Compute::Cloudstack::BadRequest
          nil
        end
      end

    end
  end
end
