module Fog
  module Compute
    class Google
      class Mock
        def start_server(identity, zone_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def start_server(identity, zone_name)
          api_method = @compute.instances.start
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
