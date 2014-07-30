module Fog
  module Compute
    class Google
      class Mock
        def get_backend_service(service_name)
          Fog::Mock::not_implemented
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

