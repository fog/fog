module Fog
  module Compute
    class Voxel
      class Real

        require 'fog/compute/parsers/voxel/voxcloud_delete'

        def voxcloud_delete(device_id)
          options = {
            :device_id  => device_id,
            :parser     => Fog::Parsers::Compute::Voxel::VoxcloudDelete.new
          }

          request("voxel.voxcloud.delete", options)
        end
      end

    end
  end
end
