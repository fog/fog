module Fog
  module Compute
    class Google
      class Mock
        def get_backend_services(service_name)
          Fog::Mock::not_implemented
        end
      end

      class Real
        def get_backend_services(service_name)
          api_method = @compute.backend_services.get
          parameters = {
            'project' => @project,
            'backendService' => service_name
          }
          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
