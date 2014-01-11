module Fog
  module Compute
    class Google

      class Mock
        def attach_disk(instance, zone, deviceName)
          Fog::Mock.not_implemented
        end
      end

      class Real

        def attach_disk(instance, zone_name_or_url, device_name)
          api_method = @compute.instances.attach_disk

          parameters = instance_request_parameters(instance, zone_name_or_url)

          body_object = { "deviceName" => device_name }
          result = self.build_result(api_method, parameters, body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
