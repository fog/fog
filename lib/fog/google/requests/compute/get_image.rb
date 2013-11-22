module Fog
  module Compute
    class Google

      class Mock

        def get_image(image_name, project=@project)
          image = data(project)[:images][image_name] || {
            "error" => {
              "errors" => [
                {
                  "domain" => "global",
                  "reason" => "invalid",
                  "message" => "Invalid value for field 'resource.images': 'https://www.googleapis.com/compute/#{api_version}/projects/#{project}/global/images/#{image_name}'.  Resource was not found."
                }
              ],
              "code" => 400,
              "message" => "Invalid value for field 'resource.images': 'https://www.googleapis.com/compute/#{api_version}/projects/#{project}/global/images/#{image_name}'.  Resource was not found."
            }
          }
          build_response(:body => image)
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
