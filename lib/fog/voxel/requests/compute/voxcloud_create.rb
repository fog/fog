module Fog
  module Compute
    class Voxel
      class Real

        require 'fog/voxel/parsers/compute/voxcloud_create'

        def voxcloud_create(options)
          options[:parser] = Fog::Parsers::Compute::Voxel::VoxcloudCreate.new

          if options.has_key?(:password)
            options[:admin_password] = options[:password]
            options.delete(:password)
          end

          request("voxel.voxcloud.create", options)
        end
      end

    end
  end
end
