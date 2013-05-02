  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Update password of a host/pool on management server.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateHostPassword.html]
          def update_host_password(options={})
            options.merge!(
              'command' => 'updateHostPassword'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
