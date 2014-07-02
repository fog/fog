module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a F5 external load balancer appliance added in a zone.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteExternalLoadBalancer.html]
        def delete_external_load_balancer(id, options={})
          options.merge!(
            'command' => 'deleteExternalLoadBalancer', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

