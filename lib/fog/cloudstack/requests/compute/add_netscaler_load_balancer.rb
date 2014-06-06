module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a netscaler load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addNetscalerLoadBalancer.html]
        def add_netscaler_load_balancer(password, username, physicalnetworkid, networkdevicetype, url, options={})
          options.merge!(
            'command' => 'addNetscalerLoadBalancer', 
            'password' => password, 
            'username' => username, 
            'physicalnetworkid' => physicalnetworkid, 
            'networkdevicetype' => networkdevicetype, 
            'url' => url  
          )
          request(options)
        end
      end

    end
  end
end

