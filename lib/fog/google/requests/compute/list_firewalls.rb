module Fog
  module Compute
    class Google
      class Mock
        def list_firewalls
          Fog::Mock.not_implemented
        end
      end

      class Real
        def list_firewalls
          api_method = @compute.firewalls.list
          parameters = {
            'project' => @project
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
