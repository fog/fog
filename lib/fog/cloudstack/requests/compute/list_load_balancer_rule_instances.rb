module Fog
  module Compute
    class Cloudstack

      class Real
        # List all virtual machine instances that are assigned to a load balancer rule.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listLoadBalancerRuleInstances.html]
        def list_load_balancer_rule_instances(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listLoadBalancerRuleInstances') 
          else
            options.merge!('command' => 'listLoadBalancerRuleInstances', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

