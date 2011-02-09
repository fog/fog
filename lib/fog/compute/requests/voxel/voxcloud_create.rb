module Fog
  module Voxel
    class Compute
      class Real
        def voxcloud_create( options )
          data = request("voxel.voxcloud.create", options)

          unless data['stat'] == 'ok'
            raise "Error from hAPI: #{data['err']['msg']}"
          end

          devices_list(data['device']['id'])
        end
      end

      class Mock
        def voxcloud_create( options )
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
