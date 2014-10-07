module Fog
  module Compute
    class Cloudstack

      class Real
        # lists network that are using a netscaler load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listNetscalerLoadBalancerNetworks.html]
        def list_netscaler_load_balancer_networks(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listNetscalerLoadBalancerNetworks') 
          else
            options.merge!('command' => 'listNetscalerLoadBalancerNetworks', 
            'lbdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

