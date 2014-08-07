module Fog
  module Compute
    class Google
      class Mock
        def get_backend_service(service_name)
          backend_service = self.data[:backend_services][service_name]
          if backend_service.nil?
            return nil
          end
          build_excon_response(backend_service)
        end
      end
 
      class Real
        def get_backend_service(service_name)
          api_method = @compute.backend_services.get
          parameters = {
            'project' => @project,
            'backendService' => service_name
          }
          request(api_method, parameters)
        end
      end
    end
  end
end
