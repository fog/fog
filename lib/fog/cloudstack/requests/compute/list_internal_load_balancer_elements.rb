module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available Internal Load Balancer elements.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listInternalLoadBalancerElements.html]
        def list_internal_load_balancer_elements(options={})
          options.merge!(
            'command' => 'listInternalLoadBalancerElements'  
          )
          request(options)
        end
      end

    end
  end
end

