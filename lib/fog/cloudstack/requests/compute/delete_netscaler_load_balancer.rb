module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a netscaler load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteNetscalerLoadBalancer.html]
        def delete_netscaler_load_balancer(lbdeviceid, options={})
          options.merge!(
            'command' => 'deleteNetscalerLoadBalancer', 
            'lbdeviceid' => lbdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

