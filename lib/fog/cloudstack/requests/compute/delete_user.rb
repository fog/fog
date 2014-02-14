  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a user for an account
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteUser.html]
          def delete_user(options={})
            options.merge!(
              'command' => 'deleteUser'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
