require 'fog/core/collection'
require 'fog/compute/models/voxel/server'

module Fog
  module Voxel
    class Compute
      class Servers < Fog::Collection

        model Fog::Voxel::Compute::Server

        def all
          data = connection.devices_list
          statuses = connection.voxcloud_status
          
          data.each_index do |i|
            data[i][:status] = statuses.select { |s| s[:id] == data[i][:id] }.first[:status]
          end

          load(data)
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server
        end

        def get(device_id)
          if device_id && server = connection.devices_list(device_id)
           
						if server.empty?
							nil
						else
							status = connection.voxcloud_status(device_id)
							server.first[:status] = status.first[:status]
							new(server.first)
						end
          end
        end

      end

    end
  end
end
