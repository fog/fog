module Fog
  module Compute
    class Cloudstack

      class Real
        # configures a netscaler load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/configureNetscalerLoadBalancer.html]
        def configure_netscaler_load_balancer(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'configureNetscalerLoadBalancer') 
          else
            options.merge!('command' => 'configureNetscalerLoadBalancer', 
            'lbdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

