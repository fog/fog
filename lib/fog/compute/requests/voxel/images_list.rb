module Fog
  module Voxel
    class Compute
      class Real
        def images_list
          response = Excon::Response.new
          data = request("voxel_images_list", { :verbosity => 'compact' })
          images = []
          response.status = 200
          response.body = { 'images' => images }
          response
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
