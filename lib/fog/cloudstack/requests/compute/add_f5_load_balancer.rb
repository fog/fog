module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a F5 BigIP load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addF5LoadBalancer.html]
        def add_f5_load_balancer(options={})
          request(options)
        end


        def add_f5_load_balancer(password, physicalnetworkid, networkdevicetype, username, url, options={})
          options.merge!(
            'command' => 'addF5LoadBalancer', 
            'password' => password, 
            'physicalnetworkid' => physicalnetworkid, 
            'networkdevicetype' => networkdevicetype, 
            'username' => username, 
            'url' => url  
          )
          request(options)
        end
      end

    end
  end
end

