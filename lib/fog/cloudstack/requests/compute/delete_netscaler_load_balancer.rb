module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a netscaler load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteNetscalerLoadBalancer.html]
        def delete_netscaler_load_balancer(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteNetscalerLoadBalancer') 
          else
            options.merge!('command' => 'deleteNetscalerLoadBalancer', 
            'lbdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

