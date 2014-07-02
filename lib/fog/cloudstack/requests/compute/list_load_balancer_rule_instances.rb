module Fog
  module Compute
    class Cloudstack

      class Real
        # List all virtual machine instances that are assigned to a load balancer rule.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listLoadBalancerRuleInstances.html]
        def list_load_balancer_rule_instances(id, options={})
          options.merge!(
            'command' => 'listLoadBalancerRuleInstances', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

