module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a load balancer rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createLoadBalancerRule.html]
        def create_load_balancer_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createLoadBalancerRule') 
          else
            options.merge!('command' => 'createLoadBalancerRule', 
            'name' => args[0], 
            'privateport' => args[1], 
            'algorithm' => args[2], 
            'publicport' => args[3])
          end
          request(options)
        end
      end

    end
  end
end

