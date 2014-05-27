module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a virtual machine or a list of virtual machines from a load balancer rule.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeFromLoadBalancerRule.html]
        def remove_from_load_balancer_rule(options={})
          options.merge!(
            'command' => 'removeFromLoadBalancerRule', 
            'virtualmachineids' => options['virtualmachineids'], 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

