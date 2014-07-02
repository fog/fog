module Fog
  module Compute
    class Cloudstack

      class Real
        # lists network that are using a F5 load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listF5LoadBalancerNetworks.html]
        def list_f5_load_balancer_networks(lbdeviceid, options={})
          options.merge!(
            'command' => 'listF5LoadBalancerNetworks', 
            'lbdeviceid' => lbdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

