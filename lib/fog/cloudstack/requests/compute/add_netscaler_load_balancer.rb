module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a netscaler load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addNetscalerLoadBalancer.html]
        def add_netscaler_load_balancer(options={})
          options.merge!(
            'command' => 'addNetscalerLoadBalancer', 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'url' => options['url'], 
            'password' => options['password'], 
            'networkdevicetype' => options['networkdevicetype'], 
            'username' => options['username']  
          )
          request(options)
        end
      end

    end
  end
end

