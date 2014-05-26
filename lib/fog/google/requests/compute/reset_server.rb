module Fog
  module Compute
    class Google
      class Mock
        def reset_server(identity, zone)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def reset_server(identity, zone)
          api_method = @compute.instances.reset
          parameters = {
            'project'  => @project,
            'instance' => identity,
            'zone'     => zone.split('/')[-1],
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
