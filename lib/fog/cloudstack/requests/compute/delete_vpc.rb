  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a VPC
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteVPC.html]
          def delete_vpc(options={})
            options.merge!(
              'command' => 'deleteVPC'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
