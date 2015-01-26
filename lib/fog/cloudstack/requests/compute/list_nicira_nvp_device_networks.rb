module Fog
  module Compute
    class Cloudstack

      class Real
        # lists network that are using a nicira nvp device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listNiciraNvpDeviceNetworks.html]
        def list_nicira_nvp_device_networks(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listNiciraNvpDeviceNetworks') 
          else
            options.merge!('command' => 'listNiciraNvpDeviceNetworks', 
            'nvpdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

