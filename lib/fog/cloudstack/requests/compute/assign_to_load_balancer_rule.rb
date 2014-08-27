module Fog
  module Compute
    class Cloudstack

      class Real
        # Assigns virtual machine or a list of virtual machines to a load balancer rule.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/assignToLoadBalancerRule.html]
        def assign_to_load_balancer_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'assignToLoadBalancerRule') 
          else
            options.merge!('command' => 'assignToLoadBalancerRule', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

