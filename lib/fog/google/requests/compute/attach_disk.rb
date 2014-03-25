module Fog
  module Compute
    class Google

      class Mock
        def attach_disk(instance, zone, deviceName)
          Fog::Mock.not_implemented
        end
      end

      class Real

        def attach_disk(instance, zone, deviceName)
          api_method = @compute.instances.attach_disk
          parameters = {
            'project' => @project,
            'instance' => instance,
            'zone' => zone
          }
          body_object = {
            "deviceName" => deviceName
          }
          result = self.build_result(api_method, parameters, body_object=body_object)
          response = self.build_response(result)
        end
      end
    end
  end
end
