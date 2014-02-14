  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Logs out the user
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/logout.html]
          def logout(options={})
            options.merge!(
              'command' => 'logout'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
