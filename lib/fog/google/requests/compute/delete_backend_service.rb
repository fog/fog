module Fog
  module Compute
    class Google
      class Mock
        def delete_backend_service(backend_service_name, zone_name= nil)
          get_backend_service(backend_service_name)
          backend_service = self.data[:backend_services][backend_service_name]
          backend_service["mock-deletionTimestamp"] = Time.now.iso8601
          backend_service["status"] = "DONE"
          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/backendServices/#{backend_service_name}",
            "targetId" => self.data[:backend_services][backend_service_name]["id"],
            "status" => "DONE",
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
        def delete_backend_service(backend_service_name)
          api_method = @compute.backend_services.delete
          parameters = {
            'project' => @project,
            'backendService' => backend_service_name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
