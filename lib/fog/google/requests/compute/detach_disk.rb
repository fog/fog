module Fog
  module Compute
    class Google

      class Mock

        def detach_disk(instance_name, device_name, zone_name, options = {})
          Fog::Mock.not_implemented
        end

      end

      class Real

        def detach_disk(instance_name, zone_name_or_url, device_name)
          api_method = @compute.instances.detach_disk
          
          parameters = instance_request_parameters(instance_name, zone_name_or_url)
          parameters.medrge!({ 'deviceName' => device_name })
          
          result = self.build_result(api_method, parameters, body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
