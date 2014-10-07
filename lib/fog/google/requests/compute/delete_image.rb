module Fog
  module Compute
    class Google
      class Mock
        def delete_image(image_name)
          get_image(image_name)

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/images/#{image_name}",
            "targetId" => self.data[:images][image_name]["id"],
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/operations/#{operation}"
          }
          self.data[:images].delete image_name

          build_excon_response(self.data[:operations][operation])
        end
      end

      class Real
        def delete_image(image_name)
          api_method = @compute.images.delete
          parameters = {
            'project' => @project,
            'image' => image_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
