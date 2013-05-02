  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # lists network that are using a nicira nvp device
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listNiciraNvpDeviceNetworks.html]
          def list_nicira_nvp_device_networks(options={})
            options.merge!(
              'command' => 'listNiciraNvpDeviceNetworks'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
