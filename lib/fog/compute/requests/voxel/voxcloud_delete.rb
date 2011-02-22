module Fog
  module Voxel
    class Compute
      class Real
        def voxcloud_delete( device_id )
          options = { :device_id => device_id }
          data = request( "voxel.voxcloud.delete", { :device_id => device_id }, Fog::Parsers::Voxel::Compute::VoxcloudDelete.new ).body

          unless data[:stat] == 'ok'
            raise Fog::Voxel::Compute::NotFound, "Error from Voxel hAPI: #{data[:error]}"
          end
          
          true
        end
      end

      class Mock
        def voxcloud_delete( device_id )
          device = @data[:servers].select { |d| d[:id] == device_id }

          if device.empty?
            raise Fog::Voxel::Compute::NotFound
          else
            @data[:servers] = @data[:servers].select { |d| d[:id] != device_id }
            @data[:statuses].delete(device_id)
            true
          end
        end
      end
    end
  end
end
