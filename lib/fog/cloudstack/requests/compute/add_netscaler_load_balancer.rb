module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a netscaler load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addNetscalerLoadBalancer.html]
        def add_netscaler_load_balancer(options={})
          request(options)
        end


        def add_netscaler_load_balancer(username, networkdevicetype, password, physicalnetworkid, url, options={})
          options.merge!(
            'command' => 'addNetscalerLoadBalancer', 
            'username' => username, 
            'networkdevicetype' => networkdevicetype, 
            'password' => password, 
            'physicalnetworkid' => physicalnetworkid, 
            'url' => url  
          )
          request(options)
        end
      end

    end
  end
end

