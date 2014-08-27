module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a load balancer rule association with global load balancer rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/removeFromGlobalLoadBalancerRule.html]
        def remove_from_global_load_balancer_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'removeFromGlobalLoadBalancerRule') 
          else
            options.merge!('command' => 'removeFromGlobalLoadBalancerRule', 
            'id' => args[0], 
            'loadbalancerrulelist' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

