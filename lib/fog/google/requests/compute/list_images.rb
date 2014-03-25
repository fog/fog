module Fog
  module Compute
    class Google

      class Mock

        def list_images(project=@project)
          images = data(project)[:images].values
          build_response(:body => {
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

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
