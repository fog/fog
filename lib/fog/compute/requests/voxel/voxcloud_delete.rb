module Fog
  module Voxel
    class Compute
      class Real
        def voxcloud_delete(device_id)
          options = {
            :device_id  => device_id,
            :parser     => Fog::Parsers::Voxel::Compute::VoxcloudDelete.new
          }

          request("voxel.voxcloud.delete", options)
        end
      end

      class Mock
        def voxcloud_delete(device_id)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
