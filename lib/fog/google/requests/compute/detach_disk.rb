module Fog
  module Compute
    class Google

      class Mock
          def detach_disk(instance, zone_name, device_name)
          Fog::Mock.not_implemented
        end

      end

      class Real
        
        def detach_disk(instance, zone_name, device_name)
          api_method = @compute.instances.detach_disk
          parameters = {
            'project' => @project,
			'instance' => instance,
			'zone' => zone_name,
			'deviceName' => device_name
          }
          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end

      end

    end
  end
end
