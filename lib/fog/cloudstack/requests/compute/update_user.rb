  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a user account
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateUser.html]
          def update_user(options={})
            options.merge!(
              'command' => 'updateUser'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
