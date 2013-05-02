  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Enables a user account
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/enableUser.html]
          def enable_user(options={})
            options.merge!(
              'command' => 'enableUser'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
