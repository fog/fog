  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a Load Balancer stickiness policy 
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createLBStickinessPolicy.html]
          def create_lbstickiness_policy(options={})
            options.merge!(
              'command' => 'createLBStickinessPolicy'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
