module Fog
  module Compute
    class Google
      class Mock
        def list_images(project=@project)
          images = data(project)[:images].values
          build_excon_response({
            "kind" => "compute#imageList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{project}/global/images",
            "id" => "projects/#{project}/global/images",
            "items" => images
          })
        end
      end

      class Real
        def list_images(project=nil)
          api_method = @compute.images.list
          project=@project if project.nil?
          parameters = {
            'project' => project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
