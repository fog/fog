module Fog
  module Compute
    class Cloudstack

      class Real
        # lists F5 load balancer devices
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listF5LoadBalancers.html]
        def list_f5_load_balancers(options={})
          options.merge!(
            'command' => 'listF5LoadBalancers'  
          )
          request(options)
        end
      end

    end
  end
end

