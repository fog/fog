module Fog
  module Compute
    class Voxel
      class Real

        require 'fog/voxel/parsers/compute/devices_list'

        def devices_list(device_id = nil)
          options = {
            :parser     => Fog::Parsers::Compute::Voxel::DevicesList.new,
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
