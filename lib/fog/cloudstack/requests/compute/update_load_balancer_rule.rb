module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates load balancer
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateLoadBalancerRule.html]
        def update_load_balancer_rule(options={})
          options.merge!(
            'command' => 'updateLoadBalancerRule', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

