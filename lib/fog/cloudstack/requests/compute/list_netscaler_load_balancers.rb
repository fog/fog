module Fog
  module Compute
    class Cloudstack

      class Real
        # lists netscaler load balancer devices
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNetscalerLoadBalancers.html]
        def list_netscaler_load_balancers(options={})
          options.merge!(
            'command' => 'listNetscalerLoadBalancers'  
          )
          request(options)
        end
      end

    end
  end
end

