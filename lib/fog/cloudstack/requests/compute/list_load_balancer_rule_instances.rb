  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # List all virtual machine instances that are assigned to a load balancer rule.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/listLoadBalancerRuleInstances.html]
          def list_load_balancer_rule_instances(options={})
            options.merge!(
              'command' => 'listLoadBalancerRuleInstances'
            )
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
