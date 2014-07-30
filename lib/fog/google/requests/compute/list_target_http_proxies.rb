module Fog
  module Compute
    class Google
      class Mock
        def list_target_http_proxies
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_target_http_proxies
          api_method = @compute.target_http_proxies.list
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

