module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a load balancer HealthCheck policy.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteLBHealthCheckPolicy.html]
        def delete_lb_health_check_policy(id, options={})
          options.merge!(
            'command' => 'deleteLBHealthCheckPolicy', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

