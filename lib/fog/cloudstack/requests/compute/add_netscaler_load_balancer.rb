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
            'username' => options['username'], 
            'password' => options['password'], 
            'url' => options['url'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'networkdevicetype' => options['networkdevicetype']  
          )
          request(options)
        end
      end

    end
  end
end

