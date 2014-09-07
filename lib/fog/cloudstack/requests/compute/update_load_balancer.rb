module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates a Load Balancer
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateLoadBalancer.html]
        def update_load_balancer(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateLoadBalancer') 
          else
            options.merge!('command' => 'updateLoadBalancer', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

