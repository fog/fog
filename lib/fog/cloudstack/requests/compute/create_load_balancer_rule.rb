module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a load balancer rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createLoadBalancerRule.html]
        def create_load_balancer_rule(options={})
          request(options)
        end


        def create_load_balancer_rule(name, privateport, algorithm, publicport, options={})
          options.merge!(
            'command' => 'createLoadBalancerRule', 
            'name' => name, 
            'privateport' => privateport, 
            'algorithm' => algorithm, 
            'publicport' => publicport  
          )
          request(options)
        end
      end

    end
  end
end

