module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a load balancer HealthCheck policy.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteLBHealthCheckPolicy.html]
        def delete_lb_health_check_policy(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteLBHealthCheckPolicy') 
          else
            options.merge!('command' => 'deleteLBHealthCheckPolicy', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

