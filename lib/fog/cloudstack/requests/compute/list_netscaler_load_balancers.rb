module Fog
  module Compute
    class Cloudstack

      class Real
        # lists netscaler load balancer devices
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listNetscalerLoadBalancers.html]
        def list_netscaler_load_balancers(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listNetscalerLoadBalancers') 
          else
            options.merge!('command' => 'listNetscalerLoadBalancers')
          end
          request(options)
        end
      end

    end
  end
end

