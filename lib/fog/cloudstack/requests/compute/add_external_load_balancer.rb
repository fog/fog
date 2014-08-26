module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds F5 external load balancer appliance.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addExternalLoadBalancer.html]
        def add_external_load_balancer(options={})
          request(options)
        end


        def add_external_load_balancer(zoneid, url, password, username, options={})
          options.merge!(
            'command' => 'addExternalLoadBalancer', 
            'zoneid' => zoneid, 
            'url' => url, 
            'password' => password, 
            'username' => username  
          )
          request(options)
        end
      end

    end
  end
end

