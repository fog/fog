  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates VPC offering
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createVPCOffering.html]
          def create_vpcoffering(options={})
            options.merge!(
              'command' => 'createVPCOffering'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
