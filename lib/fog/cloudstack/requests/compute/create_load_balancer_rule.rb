module Fog
  module Compute
    class Cloudstack
      class Real

        # Creates a load balancer rule
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.11/global_admin/createLoadBalancerRule.html]
        def create_load_balancer_rule(options={})
          options.merge!(
            'command' => 'createLoadBalancerRule'
          )

          request(options)
        end

      end
    end
  end
end
