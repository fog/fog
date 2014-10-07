module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a virtual machine or a list of virtual machines from a load balancer rule.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/removeFromLoadBalancerRule.html]
        def remove_from_load_balancer_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'removeFromLoadBalancerRule') 
          else
            options.merge!('command' => 'removeFromLoadBalancerRule', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

