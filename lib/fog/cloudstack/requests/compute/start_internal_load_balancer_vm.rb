module Fog
  module Compute
    class Cloudstack

      class Real
        # Starts an existing internal lb vm.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/startInternalLoadBalancerVM.html]
        def start_internal_load_balancer_vm(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'startInternalLoadBalancerVM') 
          else
            options.merge!('command' => 'startInternalLoadBalancerVM', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

