module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a F5 BigIP load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/addF5LoadBalancer.html]
        def add_f5_load_balancer(options={})
          options.merge!(
            'command' => 'addF5LoadBalancer', 
            'username' => options['username'], 
            'url' => options['url'], 
            'physicalnetworkid' => options['physicalnetworkid'], 
            'networkdevicetype' => options['networkdevicetype'], 
            'password' => options['password']  
          )
          request(options)
        end
      end

    end
  end
end

