module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures an Internal Load Balancer element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/configureInternalLoadBalancerElement.html]
        def configure_internal_load_balancer_element(id, enabled, options={})
          options.merge!(
            'command' => 'configureInternalLoadBalancerElement', 
            'id' => id, 
            'enabled' => enabled  
          )
          request(options)
        end
      end

    end
  end
end

