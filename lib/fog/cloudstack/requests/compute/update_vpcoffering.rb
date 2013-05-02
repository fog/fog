  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Updates VPC offering
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/updateVPCOffering.html]
          def update_vpcoffering(options={})
            options.merge!(
              'command' => 'updateVPCOffering'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
