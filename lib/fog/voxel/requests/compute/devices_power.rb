module Fog
  module Compute
    class Voxel
      class Real

        require 'fog/voxel/parsers/compute/basic'

        def devices_power(device_id, power_action)
          options = {
            :device_id    => device_id,
            :parser       => Fog::Parsers::Compute::Voxel::Basic.new,
            :power_action => power_action,
            :verbosity    => 'normal'
          }

          request("voxel.devices.power", options)
        end
      end

    end
  end
end
