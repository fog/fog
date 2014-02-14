  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Restarts a VPC
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/restartVPC.html]
          def restart_vpc(options={})
            options.merge!(
              'command' => 'restartVPC'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
