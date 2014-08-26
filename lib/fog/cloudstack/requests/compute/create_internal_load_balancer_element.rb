module Fog
  module Compute
    class Cloudstack

      class Real
        # Create an Internal Load Balancer element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createInternalLoadBalancerElement.html]
        def create_internal_load_balancer_element(nspid, options={})
          options.merge!(
            'command' => 'createInternalLoadBalancerElement', 
            'nspid' => nspid  
          )
          request(options)
        end
      end

    end
  end
end

