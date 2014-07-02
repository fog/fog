module Fog
  module Compute
    class Cloudstack

      class Real
        # lists network that are using a netscaler load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listNetscalerLoadBalancerNetworks.html]
        def list_netscaler_load_balancer_networks(lbdeviceid, options={})
          options.merge!(
            'command' => 'listNetscalerLoadBalancerNetworks', 
            'lbdeviceid' => lbdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

