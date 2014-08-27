module Fog
  module Compute
    class Cloudstack

      class Real
        # lists network that are using a F5 load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listF5LoadBalancerNetworks.html]
        def list_f5_load_balancer_networks(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listF5LoadBalancerNetworks') 
          else
            options.merge!('command' => 'listF5LoadBalancerNetworks', 
            'lbdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

