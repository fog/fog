module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates LB HealthCheck policy
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateLBHealthCheckPolicy.html]
        def update_lb_health_check_policy(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateLBHealthCheckPolicy') 
          else
            options.merge!('command' => 'updateLBHealthCheckPolicy', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

