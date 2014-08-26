module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates LB HealthCheck policy
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateLBHealthCheckPolicy.html]
        def update_lb_health_check_policy(options={})
          request(options)
        end


        def update_lb_health_check_policy(id, options={})
          options.merge!(
            'command' => 'updateLBHealthCheckPolicy', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

