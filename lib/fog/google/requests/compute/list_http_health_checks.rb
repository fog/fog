module Fog
  module Compute
    class Google
      class Mock
        def list_http_health_checks
          health_checks = self.data[:http_health_checks].values

          build_excon_response({
            "kind" => "compute#urlMapList",
            "selfLink" => "https://www.googleapis.com/compute/#{api_version}/projects/#{@project}/global/httpHealthChecks",
            "id" => "projects/#{@project}/global/httpHealthChecks",
            "items" => health_checks
          })
        end
      end

      class Real
        def list_http_health_checks
          api_method = @compute.http_health_checks.list
          parameters = {
            'project' => @project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
