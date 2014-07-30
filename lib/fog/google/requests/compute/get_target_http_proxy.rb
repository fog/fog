module Fog
  module Compute
    class Google
      class Mock
        def get_target_http_proxy(name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_target_http_proxy(name)
          api_method = @compute.target_http_proxies.get
          parameters = {
            'project' => @project,
            'targetHttpProxy' => name
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
