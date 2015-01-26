module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all available Internal Load Balancer elements.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listInternalLoadBalancerElements.html]
        def list_internal_load_balancer_elements(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listInternalLoadBalancerElements') 
          else
            options.merge!('command' => 'listInternalLoadBalancerElements')
          end
          request(options)
        end
      end

    end
  end
end

