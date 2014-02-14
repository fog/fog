  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a VPC
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createVPC.html]
          def create_vpc(options={})
            options.merge!(
              'command' => 'createVPC'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
