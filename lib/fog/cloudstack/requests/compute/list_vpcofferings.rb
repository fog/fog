  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Lists VPC offerings
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listVPCOfferings.html]
          def list_vpcofferings(options={})
            options.merge!(
              'command' => 'listVPCOfferings'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
