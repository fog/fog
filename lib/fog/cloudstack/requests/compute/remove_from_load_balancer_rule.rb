module Fog
  module Compute
    class Cloudstack
      class Real

        # Removes a virtual machine or a list of virtual machines from a load balancer rule.
        #
        # {CloudStack API Reference}[http://download.cloud.com/releases/2.2.0/api_2.2.12/global_admin/removeFromLoadBalancerRule.html]
        def remove_from_load_balancer_rule(id,virtualmachineids=[])
          virtualmachineids = [*virtualmachineids]
          
          options = {
            'command' => 'removeFromLoadBalancerRule',
            'id' => id,
            'virtualmachineids' => virtualmachineids.join(',')
          }

          request(options)
        end

      end
    end
  end
end

