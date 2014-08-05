module Fog
  module Compute
    class Cloudstack

      class Real
        # configures a netscaler load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/configureNetscalerLoadBalancer.html]
        def configure_netscaler_load_balancer(lbdeviceid, options={})
          options.merge!(
            'command' => 'configureNetscalerLoadBalancer', 
            'lbdeviceid' => lbdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

