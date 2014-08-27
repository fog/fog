module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists BigSwitch Vns devices
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listBigSwitchVnsDevices.html]
        def list_big_switch_vns_devices(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listBigSwitchVnsDevices') 
          else
            options.merge!('command' => 'listBigSwitchVnsDevices')
          end
          request(options)
        end
      end

    end
  end
end

