module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a load balancer
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteLoadBalancer.html]
        def delete_load_balancer(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteLoadBalancer') 
          else
            options.merge!('command' => 'deleteLoadBalancer', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

