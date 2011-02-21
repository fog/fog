module Fog
  module Voxel
    class Compute
      class Real
        def devices_list( device_id = nil )
          # name, processing_cores, status, facility
          options = { :verbosity => 'normal' }

          unless device_id.nil?
            options[:device_id] = device_id
          end

          data = request("voxel.devices.list", options, Fog::Parsers::Voxel::Compute::DevicesList.new).body

          if data[:stat] == 'fail'
            raise Fog::Voxel::Compute::NotFound
          elsif data[:devices].empty?
            []
          else
            devices = data[:devices]

            ## TODO find both voxserver and voxcloud devices
            devices.select { |d| d[:type] == '3' }.map do |device|
              device.delete(:type)
              device.merge( :image_id => 0 )
            end
          end
        end
      end

      class Mock
        def devices_list( device_id = nil)
          if device_id.nil?
            @data[:servers]
          else
            result = @data[:servers].select { |d| d[:id] == device_id }

            if result.empty?
              raise Fog::Voxel::Compute::NotFound
            else
              result
            end
          end
        end
      end
    end
  end
end
