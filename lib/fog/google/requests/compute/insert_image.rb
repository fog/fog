module Fog
  module Compute
    class Google

      class Mock

        def insert_image(image_name)
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_image(image_name, source)
          api_method = @compute.images.insert
          parameters = {
            'project' => @project,
          }
          body_object = {
            "name" => image_name,
            "sourceType" => "RAW",
            "source" => source,
            "preferredKernel" => '',
          }

          result = self.build_result(
            api_method,
            parameters,
            body_object=body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
