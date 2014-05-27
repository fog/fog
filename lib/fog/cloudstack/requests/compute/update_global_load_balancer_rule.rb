module Fog
  module Compute
    class Cloudstack

      class Real
        # update global load balancer rules.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateGlobalLoadBalancerRule.html]
        def update_global_load_balancer_rule(options={})
          options.merge!(
            'command' => 'updateGlobalLoadBalancerRule', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

