module Fog
  module Voxel
    class Compute
      class Real
        def voxcloud_create(options)
          options[:parser] = Fog::Parsers::Voxel::Compute::VoxcloudCreate.new

          if options.has_key?(:password)
            options[:admin_password] = options[:password]
            options.delete(:password)
          end

          request("voxel.voxcloud.create", options)
        end
      end

      class Mock
        def voxcloud_create(options)
          Fog::Mock.not_implemented
        end
      end
    end
  end
end
