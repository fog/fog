module Fog
  module Compute
    class Cloudstack

      class Real
        # Starts an existing internal lb vm.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/startInternalLoadBalancerVM.html]
        def start_internal_load_balancer_vm(id, options={})
          options.merge!(
            'command' => 'startInternalLoadBalancerVM', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

