module Fog
  module Compute
    class Google
      class Mock
        def list_routes(options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_routes
          api_method = @compute.routes.list
          parameters = {
            'project' => @project,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
