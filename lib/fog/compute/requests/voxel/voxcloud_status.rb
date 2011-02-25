module Fog
  module Voxel
    class Compute

      require 'fog/compute/parsers/voxel/voxcloud_status'

      class Real
        def voxcloud_status(device_id = nil)
          options = {
            :parser     => Fog::Parsers::Voxel::Compute::VoxcloudStatus.new,
            :verbosity  => 'compact'
          }

          unless device_id.nil?
            options[:device_id] = device_id
          end

          request("voxel.voxcloud.status", options)
        end
      end

      class Mock
        def voxcloud_status(device_id = nil)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
