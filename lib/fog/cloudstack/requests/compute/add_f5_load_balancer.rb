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
            'physicalnetworkid' => options['physicalnetworkid'], 
            'url' => options['url'], 
            'password' => options['password'], 
            'networkdevicetype' => options['networkdevicetype'], 
             
          )
          request(options)
        end
      end

    end
  end
end

