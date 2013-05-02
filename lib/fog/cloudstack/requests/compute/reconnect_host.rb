  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Reconnects a host.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/reconnectHost.html]
          def reconnect_host(options={})
            options.merge!(
              'command' => 'reconnectHost'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
