module Fog
  module Compute
    class Google
      class Mock
        def get_route(identity)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def get_route(identity)
          api_method = @compute.routes.get
          parameters = {
            'project' => @project,
            'route' => identity,
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
