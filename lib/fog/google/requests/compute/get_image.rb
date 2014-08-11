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
                  "reason" => "notFound",
                  "message" => "The resource 'projects/#{project}/global/images/#{image_name}' was not found"
                }
              ],
              "code" => 404,
              "message" => "The resource 'projects/#{project}/global/images/#{image_name}' was not found"
            }
          }
          build_excon_response(image)
        end
      end

      class Real
        def get_image(image_name, project=@project)
          api_method = @compute.images.get
          parameters = {
            'image' => image_name,
            'project' => project,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
