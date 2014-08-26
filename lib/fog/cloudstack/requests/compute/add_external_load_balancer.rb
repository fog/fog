module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds F5 external load balancer appliance.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addExternalLoadBalancer.html]
        def add_external_load_balancer(zoneid, username, password, url, options={})
          options.merge!(
            'command' => 'addExternalLoadBalancer', 
            'zoneid' => zoneid, 
            'username' => username, 
            'password' => password, 
            'url' => url  
          )
          request(options)
        end
      end

    end
  end
end

