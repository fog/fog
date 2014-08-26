module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a F5 BigIP load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addF5LoadBalancer.html]
        def add_f5_load_balancer(url, physicalnetworkid, networkdevicetype, username, password, options={})
          options.merge!(
            'command' => 'addF5LoadBalancer', 
            'url' => url, 
            'physicalnetworkid' => physicalnetworkid, 
            'networkdevicetype' => networkdevicetype, 
            'username' => username, 
            'password' => password  
          )
          request(options)
        end
      end

    end
  end
end

