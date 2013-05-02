  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Adds a Nicira NVP device
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/addNiciraNvpDevice.html]
          def add_nicira_nvp_device(options={})
            options.merge!(
              'command' => 'addNiciraNvpDevice'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
