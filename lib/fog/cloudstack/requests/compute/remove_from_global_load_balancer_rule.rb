module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a load balancer rule association with global load balancer rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeFromGlobalLoadBalancerRule.html]
        def remove_from_global_load_balancer_rule(options={})
          options.merge!(
            'command' => 'removeFromGlobalLoadBalancerRule', 
            'loadbalancerrulelist' => options['loadbalancerrulelist'], 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

