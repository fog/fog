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

          kernel_url = @api_url + 'google/global/kernels/' + \
                      options.delete('preferredKernel').to_s

          body_object = {
            'sourceType'      => 'RAW',
            'name'            => image_name,
            'rawDisk'         => options.delete('rawDisk'),
            'preferredKernel' => kernel_url,
          }

          # Merge in the remaining params (only 'description' should remain)
          body_object.merge!(options)

          result = self.build_result(api_method,
                                     parameters,
                                     body_object=body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
