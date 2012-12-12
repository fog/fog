module Fog
  module Compute
    class Google

      class Mock

        def get_image(image_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def get_image(image_name)
          api_method = @compute.images.get
          parameters = {
            'project' => 'google',
            'image' => image_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
