require 'fog/core/collection'
require 'fog/compute/models/voxel/server'

module Fog
  module Voxel
    class Compute
      class Servers < Fog::Collection

        model Fog::Voxel::Compute::Server

        def all
          data = connection.devices_list.body['devices'].select {|device| device['type']['id'] == '3'}
          load(data)
        end

        def get(device_id)
          if device_id && server = connection.devices_list(device_id).body['devices']

            if server.empty?
              nil
            else
              new(server.first)
            end
          end
        end

      end

    end
  end
end
