module Fog
  module Voxel
    class Compute
      class Real
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

      class Mock
        def devices_list( device_id = nil)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
