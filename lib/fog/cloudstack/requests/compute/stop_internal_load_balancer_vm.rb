module Fog
  module Compute
    class Cloudstack

      class Real
        # Stops an Internal LB vm.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/stopInternalLoadBalancerVM.html]
        def stop_internal_load_balancer_vm(id, options={})
          options.merge!(
            'command' => 'stopInternalLoadBalancerVM', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

