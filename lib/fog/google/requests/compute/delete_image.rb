module Fog
  module Compute
    class Google

      class Mock

        def delete_image(image_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def delete_image(image_name)
          api_method = @compute.images.delete
          parameters = {
            'project' => @project,
            'image' => image_name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
