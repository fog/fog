module Fog
  module Voxel
    class Compute
      class Real

        require 'fog/compute/parsers/voxel/voxcloud_create'

        def voxcloud_create(options)
          options[:parser] = Fog::Parsers::Voxel::Compute::VoxcloudCreate.new

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
