module Fog
  module Compute
    class Google
      class Mock
        def delete_http_health_check(name)
          get_http_health_check(name)
          check = self.data[:http_health_checks][name]
          operation = self.random_operation
          self.data[:operations][operation] = {
            "kind" => "compute#operation",
            "id" => Fog::Mock.random_numbers(19).to_s,
            "name" => operation,
            "zone" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global",
            "operationType" => "delete",
            "targetLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/httpHealthChecks/#{name}",
            "targetId" => self.data[:http_health_checks][name]["id"],
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
        def delete_http_health_check(name)
          api_method = @compute.http_health_checks.delete
          parameters = {
            'project' => @project,
            'httpHealthCheck' => name
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
