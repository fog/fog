  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Disables a user account
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/disableUser.html]
          def disable_user(options={})
            options.merge!(
              'command' => 'disableUser'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
