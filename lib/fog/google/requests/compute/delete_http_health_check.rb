module Fog
  module Compute
    class Google

      class Mock

        def delete_http_health_check(name)
          #TODO(bensonk): make this work
        end

      end

      class Real

        def delete_http_health_check(name)
          api_method = @compute.http_health_checks.delete
          parameters = {
            'project' => @project,
            'httpHealthCheck' => name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
