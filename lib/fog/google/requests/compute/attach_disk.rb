module Fog
  module Compute
    class Google
      class Mock
        def attach_disk(instance, zone, source, options = {})
          Fog::Mock.not_implemented
        end
      end

      class Real
        def attach_disk(instance, zone, source, options = {})
          api_method = @compute.instances.attach_disk
          parameters = {
            'project' => @project,
            'instance' => instance,
            'zone' => zone.split('/')[-1],
          }

          writable = options.delete(:writable)
          body_object = {
            'type' =>       'PERSISTENT',
            'source' =>     source,
            'mode' =>       writable ? 'READ_WRITE' : 'READ_ONLY',
            'deviceName' => options.delete(:deviceName),
            'boot' =>       options.delete(:boot),
            'autoDelete' => options.delete(:autoDelete),
          }

          request(api_method, parameters, body_object)
        end
      end
    end
  end
end
