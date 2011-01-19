require 'fog/core/collection'
require 'fog/compute/models/voxel/server'

module Fog
  module Voxel
    class Compute
      class Servers < Fog::Collection

        model Fog::Voxel::Compute::Server

        def all
          data = connection.devices_list
          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server
        end

        def get(device_id)
          if device_id && server = connection.devices_list(device_id)
            new(server)
          end
        rescue Fog::Voxel::Compute::NotFound
          nil
        end

      end

    end
  end
end
