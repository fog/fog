module Fog
  module Compute
    class Cloudstack
      class Real

        # List external load balancer appliances.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.4/global_admin/listExternalLoadBalancers.html]
        def list_external_load_balancers(options={})
          options.merge!(
            'command' => 'listExternalLoadBalancers'
          )
          
          request(options)
        end

      end
    end
  end
end
