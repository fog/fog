  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a host.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateHost.html]
          def update_host(options={})
            options.merge!(
              'command' => 'updateHost'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
