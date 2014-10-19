module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists load balancer HealthCheck policies.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listLBHealthCheckPolicies.html]
        def list_lb_health_check_policies(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listLBHealthCheckPolicies') 
          else
            options.merge!('command' => 'listLBHealthCheckPolicies')
          end
          request(options)
        end
      end

    end
  end
end

