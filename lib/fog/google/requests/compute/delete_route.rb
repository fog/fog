module Fog
  module Compute
    class Google
      class Mock
        def delete_route(identity)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def delete_route(identity)
          api_method = @compute.routes.delete
          parameters = {
            'project' => @project,
            'route' => identity,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
