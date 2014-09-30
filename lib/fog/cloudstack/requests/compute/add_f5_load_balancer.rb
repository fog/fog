module Fog
  module Compute
    class Cloudstack

      class Real
        # Adds a F5 BigIP load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/addF5LoadBalancer.html]
        def add_f5_load_balancer(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'addF5LoadBalancer') 
          else
            options.merge!('command' => 'addF5LoadBalancer', 
            'password' => args[0], 
            'physicalnetworkid' => args[1], 
            'networkdevicetype' => args[2], 
            'username' => args[3], 
            'url' => args[4])
          end
          request(options)
        end
      end

    end
  end
end

