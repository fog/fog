module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures an Internal Load Balancer element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/configureInternalLoadBalancerElement.html]
        def configure_internal_load_balancer_element(options={})
          options.merge!(
            'command' => 'configureInternalLoadBalancerElement', 
            'enabled' => options['enabled'], 
            'id' => options['id']  
          )
          request(options)
        end
      end

    end
  end
end

