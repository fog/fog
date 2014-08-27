module Fog
  module Compute
    class Cloudstack

      class Real
        # configures a F5 load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/configureF5LoadBalancer.html]
        def configure_f5_load_balancer(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'configureF5LoadBalancer') 
          else
            options.merge!('command' => 'configureF5LoadBalancer', 
            'lbdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

