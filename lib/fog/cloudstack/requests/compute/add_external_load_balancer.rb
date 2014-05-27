module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds F5 external load balancer appliance.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addExternalLoadBalancer.html]
        def add_external_load_balancer(options={})
          options.merge!(
            'command' => 'addExternalLoadBalancer', 
            'password' => options['password'], 
            'username' => options['username'], 
            'url' => options['url'], 
            'zoneid' => options['zoneid']  
          )
          request(options)
        end
      end

    end
  end
end

