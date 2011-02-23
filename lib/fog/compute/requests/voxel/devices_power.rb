module Fog
  module Voxel
    class Compute
      class Real
        def devices_power(device_id, power_action)
          options = {
            :device_id    => device_id,
            :parser       => Fog::Parsers::Voxel::Compute::Basic.new,
            :power_action => power_action,
            :verbosity    => 'normal'
          }

          request("voxel.devices.power", options)
        end
      end

      class Mock
        def devices_power(device_id, power_action)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
