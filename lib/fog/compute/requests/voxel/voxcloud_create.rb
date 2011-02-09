module Fog
  module Voxel
    class Compute
      class Real
        def voxcloud_create( options )
          ## TODO Remove this
          options.merge! :customer_id => 1470

          data = request("voxel.voxcloud.create", options)

          unless data['stat'] == 'ok'
            raise "Error from Voxel hAPI: #{data['err']['msg']}"
          end

          devices_list(data['device']['id'])
        end
      end

      class Mock
        def voxcloud_create( options )
          devices_list(12345)
        end
      end
    end
  end
end
