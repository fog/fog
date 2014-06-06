module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a load balancer rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createLoadBalancerRule.html]
        def create_load_balancer_rule(publicport, algorithm, privateport, name, options={})
          options.merge!(
            'command' => 'createLoadBalancerRule', 
            'publicport' => publicport, 
            'algorithm' => algorithm, 
            'privateport' => privateport, 
            'name' => name  
          )
          request(options)
        end
      end

    end
  end
end

