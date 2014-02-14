  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Removes a virtual machine or a list of virtual machines from a load balancer rule.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/removeFromLoadBalancerRule.html]
          def remove_from_load_balancer_rule(options={})
            virtualmachineids = [*virtualmachineids]
          
            options = {
              'command' => 'removeFromLoadBalancerRule',
              'id' => id,
              'virtualmachineids' => virtualmachineids.join(',')
            }
            request(options)
          end
           
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
