  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes network device.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteNetworkDevice.html]
          def delete_network_device(options={})
            options.merge!(
              'command' => 'deleteNetworkDevice'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
