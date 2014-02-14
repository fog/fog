  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates a VPC
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateVPC.html]
          def update_vpc(options={})
            options.merge!(
              'command' => 'updateVPC'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
