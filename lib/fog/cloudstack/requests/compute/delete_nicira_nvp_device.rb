  module Fog
    module Compute
      class Cloudstack
        class Real
           
          #  delete a nicira nvp device
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteNiciraNvpDevice.html]
          def delete_nicira_nvp_device(options={})
            options.merge!(
              'command' => 'deleteNiciraNvpDevice'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
