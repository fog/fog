module Fog
  module Compute
    class Google
      class Mock
        def insert_image(image_name, options={})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_image(image_name, options={})
          api_method = @compute.images.insert

          parameters = {
            'project' => @project,
          }

          body_object = {
            'sourceType'      => 'RAW',
            'name'            => image_name,
          }

          # Merge in the remaining params 
          body_object.merge!(options)

          request(api_method, parameters, body_object=body_object)
        end
      end
    end
  end
end
