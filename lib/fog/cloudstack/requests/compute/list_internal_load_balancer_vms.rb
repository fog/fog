module Fog
  module Compute
    class Cloudstack

      class Real
        # List internal LB VMs.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listInternalLoadBalancerVMs.html]
        def list_internal_load_balancer_vms(options={})
          options.merge!(
            'command' => 'listInternalLoadBalancerVMs'  
          )
          request(options)
        end
      end

    end
  end
end

