module Fog
  module Compute
    class Cloudstack
      class Real

        # Attaches a disk volume to a virtual machine.
        #
        # {CloudStack API Reference}[http://http://download.cloud.com/releases/2.2.0/api_2.2.12/global_admin/attachVolume.html]
        def attach_volume(id,virtualmachineid,deviceid=nil)
          options = {
            'command' => 'attachVolume',
            'id' => id,
            'virtualmachineid' => virtualmachineid,
            'deviceid' => deviceid
          }

          request(options)
        end

      end
    end
  end
end
