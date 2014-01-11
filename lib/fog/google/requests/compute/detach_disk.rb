module Fog
  module Compute
    class Google

      class Mock
        def detach_disk(instance, zone, deviceName)
          Fog::Mock.not_implemented
        end
      end

      class Real

        def detach_disk(instance_name, zone_name_or_url, device_name)
          api_method = @compute.instances.detach_disk
          parameters = instance_request_parameters(instance_name, zone_name_or_url)
          body_object = { "deviceName" => device_name }
          result = self.build_result(api_method, parameters, body_object)
          response = self.build_response(result)
        end

      end

    end
  end
end
