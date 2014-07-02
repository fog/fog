module Fog
  module Compute
    class Cloudstack

      class Real
        # Assign load balancer rule or list of load balancer rules to a global load balancer rules.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/assignToGlobalLoadBalancerRule.html]
        def assign_to_global_load_balancer_rule(id, loadbalancerrulelist, options={})
          options.merge!(
            'command' => 'assignToGlobalLoadBalancerRule', 
            'id' => id, 
            'loadbalancerrulelist' => loadbalancerrulelist  
          )
          request(options)
        end
      end

    end
  end
end

