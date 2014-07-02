module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists load balancer HealthCheck policies.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listLBHealthCheckPolicies.html]
        def list_lb_health_check_policies(lbruleid, options={})
          options.merge!(
            'command' => 'listLBHealthCheckPolicies', 
            'lbruleid' => lbruleid  
          )
          request(options)
        end
      end

    end
  end
end

