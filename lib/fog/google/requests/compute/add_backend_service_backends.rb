module Fog
  module Compute
    class Google
      class Mock
        def add_backend_service_backends(backend_service, new_backends)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def add_backend_service_backends(backend_service, new_backends)
          api_method = @compute.backend_services.patch
          parameters = {
            'project' => @project,
            'backendService' => backend_service.name,
          }
          if backend_service.backends then
            backend_service.backends.concat(new_backends)
          else
            backend_service.backends = new_backends
          end
          body_object = backend_service
          
          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
