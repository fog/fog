module Fog
  module Compute
    class Google
      class Mock
        def insert_image(image_name, options={})
          id = Fog::Mock.random_numbers(19).to_s
          object = {
            "kind" => "compute#image",
            "id" => id,
            "creationTimestamp" => Time.now.iso8601,
            "sourceType" => '',
            "rawDisk" => {
              "source" => options ["source"],
              "shal1Checksum" => '',
              "containerType" => ''
            },
            "status" => "READY",
            "name" => image_name,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/images/#{image_name}"
          }
          self.data[:images][image_name] = object

          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "operationType" => "insert",
            "targetLink" => object["selfLink"],
            "targetId" => id,
            "status" => Fog::Compute::Google::Operation::PENDING_STATE,
            "user" => "123456789012-qwertyuiopasdfghjkl1234567890qwe@developer.gserviceaccount.com",
            "progress" => 0,
            "insertTime" => Time.now.iso8601,
            "startTime" => Time.now.iso8601,
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/operations/#{operation}"
          }

          build_excon_response(self.data[:operations][operation])
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
