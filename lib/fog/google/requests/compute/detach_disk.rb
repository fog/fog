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

          request(api_method, parameters)
        end
      end
    end
  end
end
