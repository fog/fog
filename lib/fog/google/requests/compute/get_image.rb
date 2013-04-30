module Fog
  module Compute
    class Google

      class Mock

        def get_image(image_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def get_image(image_name, project=@project)
          api_method = @compute.images.get
          parameters = {
            'image' => image_name,
            'project' => project,
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
