  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Deletes a load balancer rule.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/deleteLoadBalancerRule.html]
          def delete_load_balancer_rule(options={})
            options.merge!(
              'command' => 'deleteLoadBalancerRule'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
