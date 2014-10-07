module Fog
  module Compute
    class Google
      class Mock
        def get_http_health_check(name)
          http_health_check = self.data[:http_health_checks][name]
          if http_health_check.nil?
            return build_excon_response({
              "error" => {
                "errors" => [
                 {
                  "domain" => "global",
                  "reason" => "notFound",
                  "message" => "The resource 'projects/#{@project}/global/httpHealthChecks/#{name}' was not found"
                 }
                ],
                "code" => 404,
                "message" => "The resource 'projects/#{@project}/global/httpHealthChecks/#{name}' was not found"
              }
            })
          end
          build_excon_response(http_health_check)
        end
      end

      class Real
        def get_http_health_check(name)
          api_method = @compute.http_health_checks.get
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
