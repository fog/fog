module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists F5 external load balancer appliances added in a zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listExternalLoadBalancers.html]
        def list_external_load_balancers(options={})
          options.merge!(
            'command' => 'listExternalLoadBalancers'  
          )
          request(options)
        end
      end

    end
  end
end

