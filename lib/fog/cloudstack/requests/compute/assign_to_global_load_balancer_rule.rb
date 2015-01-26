module Fog
  module Compute
    class Cloudstack

      class Real
        # Assign load balancer rule or list of load balancer rules to a global load balancer rules.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/assignToGlobalLoadBalancerRule.html]
        def assign_to_global_load_balancer_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'assignToGlobalLoadBalancerRule') 
          else
            options.merge!('command' => 'assignToGlobalLoadBalancerRule', 
            'id' => args[0], 
            'loadbalancerrulelist' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

