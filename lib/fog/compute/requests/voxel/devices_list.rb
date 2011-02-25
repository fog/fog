module Fog
  module Voxel
    class Compute
      class Real

        require 'fog/compute/parsers/voxel/devices_list'

        def devices_list(device_id = nil)
          options = {
            :parser     => Fog::Parsers::Voxel::Compute::DevicesList.new,
            :verbosity  => 'normal'
          }

          unless device_id.nil?
            options[:device_id] = device_id
          end

          request("voxel.devices.list", options)
        end
      end

    end
  end
end
