module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists Nicira NVP devices
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNiciraNvpDevices.html]
        def list_nicira_nvp_devices(options={})
          options.merge!(
            'command' => 'listNiciraNvpDevices'  
          )
          request(options)
        end
      end

    end
  end
end

