module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a global load balancer rule.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteGlobalLoadBalancerRule.html]
        def delete_global_load_balancer_rule(options={})
          options.merge!(
            'command' => 'deleteGlobalLoadBalancerRule', 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

