module Fog
  module Compute
    class Google
      class Mock
        def list_backend_services
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_backend_services
          api_method = @compute.backend_services.list
          parameters = {
            'project' => @project,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
