module Fog
  module Compute
    class Google
      class Mock
        def reset_server(instance_name, zone_name_or_url)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def reset_server(instance_name, zone_name_or_url)
          api_method = @compute.instances.reset
          parameters = instance_request_parameters(instance_name, zone_name_or_url)
          request(api_method, parameters)
        end
      end
    end
  end
end
