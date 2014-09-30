module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists load balancer rules.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listLoadBalancerRules.html]
        def list_load_balancer_rules(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listLoadBalancerRules') 
          else
            options.merge!('command' => 'listLoadBalancerRules')
          end
          request(options)
        end
      end

    end
  end
end

