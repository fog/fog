module Fog
  module Compute
    class Google
      class Mock
        def set_server_disk_auto_delete(identity, zone, auto_delete, device_name)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def set_server_disk_auto_delete(identity, zone, auto_delete, device_name)
          api_method = @compute.instances.set_disk_auto_delete
          parameters = {
            'project'    => @project,
            'instance'   => identity,
            'zone'       => zone.split('/')[-1],
            'autoDelete' => auto_delete,
            'deviceName' => device_name,
          }

          request(api_method, parameters)
        end
      end
    end
  end
end
