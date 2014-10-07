module Fog
  module Compute
    class Cloudstack

      class Real
        # Stops an Internal LB vm.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/stopInternalLoadBalancerVM.html]
        def stop_internal_load_balancer_vm(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'stopInternalLoadBalancerVM') 
          else
            options.merge!('command' => 'stopInternalLoadBalancerVM', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

