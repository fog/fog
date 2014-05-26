module Fog
  module Compute
    class Google
      class Mock
        def detach_disk(instance, zone, deviceName)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def detach_disk(instance, zone, deviceName)
          api_method = @compute.instances.detach_disk
          parameters = {
            'project' => @project,
            'instance' => instance,
            'zone' => zone.split('/')[-1],
            'deviceName' => deviceName
          }

          result = self.build_result(api_method, parameters)
          response = self.build_response(result)
        end
      end
    end
  end
end
