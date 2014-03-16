module Fog
  module Compute
    class Google

      class Mock

        def list_http_health_checks
          raise "not implemented"
          # TODO(bensonk): make this work
          build_response(:body => {
            "kind" => "compute#httpHealthCheckList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/http_health_checks/disks",
            "id" => "projects/#{@project}/zones/#{zone_name}/http_health_checks",
            "items" => self.data[:http_health_checks]
          })
        end

      end

      class Real

        def list_http_health_checks
          api_method = @compute.http_health_checks.list
          parameters = {
            'project' => @project
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
