module Fog
  module Compute
    class Google
      class Mock
        def get_backend_service_health(backend_service)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_backend_service_health(backend_service)
          api_method = @compute.backend_services.get_health
          parameters = {
            'project' => @project,
            'backendService' => backend_service.name
          }
          health_results = backend_service.backends.map do |backend|
            body = { 'group' => backend['group'] }
            resp = request(api_method, parameters, body_object= body)
            [backend['group'], resp.data[:body]['healthStatus']]
          end
          Hash[health_results]
        end
      end
    end
  end
end
