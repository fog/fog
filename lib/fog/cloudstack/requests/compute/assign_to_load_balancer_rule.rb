module Fog
  module Compute
    class Cloudstack
      class Real

        # Assigns virtual machine or a list of virtual machines to a load balancer rule.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.12/global_admin/assignToLoadBalancerRule.html]
        def assign_to_load_balancer_rule(id,virtualmachineids=[])
          virtualmachineids = [*virtualmachineids]
          
          options = {
            'command' => 'assignToLoadBalancerRule',
            'id' => id,
            'virtualmachineids' => virtualmachineids.join(',')
          }

          request(options)
        end

      end
    end
  end
end

