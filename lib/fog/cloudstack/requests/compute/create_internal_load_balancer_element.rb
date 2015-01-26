module Fog
  module Compute
    class Cloudstack

      class Real
        # Create an Internal Load Balancer element.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createInternalLoadBalancerElement.html]
        def create_internal_load_balancer_element(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createInternalLoadBalancerElement') 
          else
            options.merge!('command' => 'createInternalLoadBalancerElement', 
            'nspid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

