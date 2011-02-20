module Fog
  module Voxel
    class Compute
      class Real
        def voxcloud_delete( device_id )
					options = { :device_id => device_id }
          data = request("voxel.voxcloud.delete", options )

          unless data['stat'] == 'ok'
            raise "Error from Voxel hAPI: #{data['err']['msg']}"
          end
					
					true
				end
      end

      class Mock
        def voxcloud_delete( device_id )
					device = @data[:devices].select { |d| d[:id] == device_id }

          if device.empty?
            false
          else
            @data[:devices] = @data[:devices].select { |d| d[:id] != device_id }
            @data[:statuses].delete(device_id)
            true
          end
				end
      end
    end
  end
end
