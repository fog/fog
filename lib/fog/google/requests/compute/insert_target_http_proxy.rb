module Fog
  module Compute
    class Google
      class Mock
        def insert_target_http_proxy(name, options={})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_target_http_proxy(name, opts={})
          api_method = @compute.target_http_proxies.insert
          parameters = {
            'project' => @project
          }
          body_object = { 'name' => name }
          body_object.merge!(opts)

          result = self.build_result(api_method, parameters, body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
