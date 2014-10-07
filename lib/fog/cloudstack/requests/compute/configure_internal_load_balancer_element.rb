module Fog
  module Compute
    class Cloudstack

      class Real
        # Configures an Internal Load Balancer element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/configureInternalLoadBalancerElement.html]
        def configure_internal_load_balancer_element(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'configureInternalLoadBalancerElement') 
          else
            options.merge!('command' => 'configureInternalLoadBalancerElement', 
            'id' => args[0], 
            'enabled' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

