  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Creates a load balancer rule
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/createLoadBalancerRule.html]
          def create_load_balancer_rule(options={})
            options.merge!(
              'command' => 'createLoadBalancerRule'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
