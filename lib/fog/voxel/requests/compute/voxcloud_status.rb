module Fog
  module Compute
    class Voxel
      class Real

        require 'fog/voxel/parsers/compute/voxcloud_status'

        def voxcloud_status(device_id = nil)
          options = {
            :parser     => Fog::Parsers::Compute::Voxel::VoxcloudStatus.new,
            :verbosity  => 'compact'
          }

          unless device_id.nil?
            options[:device_id] = device_id
          end

          request("voxel.voxcloud.status", options)
        end

      end
    end
  end
end
