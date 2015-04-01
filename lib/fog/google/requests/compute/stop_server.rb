module Fog
  module Compute
    class Google
      class Mock
        def stop_server(identity, zone_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def stop_server(identity, zone_name)
          api_method = @compute.instances.stop
          parameters = {
            'project' => @project,
            'zone' => zone_name,
            'instance' => identity,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
