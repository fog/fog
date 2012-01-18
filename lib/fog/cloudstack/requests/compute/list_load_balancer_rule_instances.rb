module Fog
  module Compute
    class Cloudstack
      class Real

        # Lists resource limits.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.12/global_admin/listLoadBalancerRuleInstances.html]
        def list_load_balancer_rule_instances(load_balancer_rule_id,options={})
          options.merge!(
            'command' => 'listLoadBalancerRuleInstances',
            'id' => load_balancer_rule_id
          )
          
          request(options)
        end

      end
    end
  end
end


