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
            new(server.first)
          end
        rescue Fog::Service::Error => error
          if error.message == "The device_id passed in can't be matched to a valid device."
            nil
          else
            raise error
          end
        end

      end

    end
  end
end
