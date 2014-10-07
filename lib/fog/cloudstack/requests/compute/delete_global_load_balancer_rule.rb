module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a global load balancer rule.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteGlobalLoadBalancerRule.html]
        def delete_global_load_balancer_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteGlobalLoadBalancerRule') 
          else
            options.merge!('command' => 'deleteGlobalLoadBalancerRule', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

