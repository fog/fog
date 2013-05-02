  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a user for an account that already exists
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createUser.html]
          def create_user(options={})
            options.merge!(
              'command' => 'createUser'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
