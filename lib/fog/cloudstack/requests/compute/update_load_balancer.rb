module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a Load Balancer
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateLoadBalancer.html]
        def update_load_balancer(options={})
          request(options)
        end


        def update_load_balancer(id, options={})
          options.merge!(
            'command' => 'updateLoadBalancer', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

