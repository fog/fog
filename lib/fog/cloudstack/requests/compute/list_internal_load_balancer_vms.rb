module Fog
  module Compute
    class Cloudstack

      class Real
        # List internal LB VMs.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listInternalLoadBalancerVMs.html]
        def list_internal_load_balancer_vms(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listInternalLoadBalancerVMs') 
          else
            options.merge!('command' => 'listInternalLoadBalancerVMs')
          end
          request(options)
        end
      end

    end
  end
end

