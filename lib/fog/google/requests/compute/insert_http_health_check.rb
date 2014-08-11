module Fog
  module Compute
    class Google
      class Mock
        def insert_http_health_check(name, options={})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def insert_http_health_check(name, opts={})
          api_method = @compute.http_health_checks.insert
          parameters = {
            'project' => @project
          }

          body_object = { 'name' => name }
          body_object.merge!(opts)

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
