module Fog
  module Voxel
    class Compute
      class Real
        def voxcloud_create( options )
          ## TODO Remove this
          options.merge! :customer_id => 1470

          data = request("voxel.voxcloud.create", options)

          unless data['stat'] == 'ok'
            raise "Error from hAPI: #{data['err']['msg']}"
          end

          devices_list(data['device']['id'])
        end
      end

      class Mock
        def images_list
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
