module Fog
  module Compute
    class Cloudstack

      class Real
        # Assigns virtual machine or a list of virtual machines to a load balancer rule.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/assignToLoadBalancerRule.html]
        def assign_to_load_balancer_rule(id, virtualmachineids, options={})
          options.merge!(
            'command' => 'assignToLoadBalancerRule', 
            'id' => id, 
            'virtualmachineids' => virtualmachineids  
          )
          request(options)
        end
      end

    end
  end
end

