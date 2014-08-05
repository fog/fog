module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates load balancer
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateLoadBalancerRule.html]
        def update_load_balancer_rule(id, options={})
          options.merge!(
            'command' => 'updateLoadBalancerRule', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

