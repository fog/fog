module Fog
  module Compute
    class Google

      class Mock

        def insert_image(image_name, options={})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def insert_image(image_name, image_source, options={})
          api_method = @compute.images.insert

          parameters = {
            'project' => @project
          }

          body_object = {
            'name'            => image_name,
            'rawDisk'         => { 'source' => image_source },
            'sourceType'      => 'RAW'
          }

          # Merge in the remaining params (only 'description' should remain)
          body_object.merge!(options)

          result = self.build_result(api_method, parameters, body_object)
          
          response = self.build_response(result)
        end

      end

    end
  end
end
