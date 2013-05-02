  module Fog
    module Compute
      class Cloudstack
        class Real
           
          # Assigns virtual machine or a list of virtual machines to a load balancer rule.
          #
          # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.0.0/root_admin/assignToLoadBalancerRule.html]
          def assign_to_load_balancer_rule(id,virtualmachineids=[])
          virtualmachineids = [*virtualmachineids]
          
          options = {
            'command' => 'assignToLoadBalancerRule',
            'id' => id,
            'virtualmachineids' => virtualmachineids.join(',')
          }

          request(options)
        end # Real
      end # Cloudstack
    end # Compute
  end # Fog
