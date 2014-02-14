  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a host.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteHost.html]
          def delete_host(options={})
            options.merge!(
              'command' => 'deleteHost'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
