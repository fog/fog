module Fog
  module Compute
    class Cloudstack

      class Real
        # configures a F5 load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/configureF5LoadBalancer.html]
        def configure_f5_load_balancer(options={})
          options.merge!(
            'command' => 'configureF5LoadBalancer',
            'lbdeviceid' => options['lbdeviceid'], 
             
          )
          request(options)
        end
      end

    end
  end
end

