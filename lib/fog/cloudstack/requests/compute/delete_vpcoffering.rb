  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes VPC offering
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteVPCOffering.html]
          def delete_vpcoffering(options={})
            options.merge!(
              'command' => 'deleteVPCOffering'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
