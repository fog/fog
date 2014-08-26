module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists BigSwitch Vns devices
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listBigSwitchVnsDevices.html]
        def list_big_switch_vns_devices(options={})
          request(options)
        end


        def list_big_switch_vns_devices(options={})
          options.merge!(
            'command' => 'listBigSwitchVnsDevices'  
          )
          request(options)
        end
      end

    end
  end
end

