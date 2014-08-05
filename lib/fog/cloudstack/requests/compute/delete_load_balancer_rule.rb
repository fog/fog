module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a load balancer rule.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteLoadBalancerRule.html]
        def delete_load_balancer_rule(id, options={})
          options.merge!(
            'command' => 'deleteLoadBalancerRule', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

