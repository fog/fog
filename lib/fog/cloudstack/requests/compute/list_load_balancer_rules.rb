module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists load balancer rules.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listLoadBalancerRules.html]
        def list_load_balancer_rules(options={})
          options.merge!(
            'command' => 'listLoadBalancerRules'  
          )
          request(options)
        end
      end

    end
  end
end

