  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Find user account by API key
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/getUser.html]
          def get_user(options={})
            options.merge!(
              'command' => 'getUser'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
