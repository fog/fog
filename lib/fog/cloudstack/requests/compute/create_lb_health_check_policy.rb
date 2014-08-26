module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a Load Balancer healthcheck policy 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createLBHealthCheckPolicy.html]
        def create_lb_health_check_policy(lbruleid, options={})
          options.merge!(
            'command' => 'createLBHealthCheckPolicy', 
            'lbruleid' => lbruleid  
          )
          request(options)
        end
      end

    end
  end
end

