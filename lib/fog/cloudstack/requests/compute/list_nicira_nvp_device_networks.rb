module Fog
  module Compute
    class Cloudstack

      class Real
        # lists network that are using a nicira nvp device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNiciraNvpDeviceNetworks.html]
        def list_nicira_nvp_device_networks(nvpdeviceid, options={})
          options.merge!(
            'command' => 'listNiciraNvpDeviceNetworks', 
            'nvpdeviceid' => nvpdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

