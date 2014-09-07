module Fog
  module Compute
    class Cloudstack

      class Real
        # lists F5 load balancer devices
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listF5LoadBalancers.html]
        def list_f5_load_balancers(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listF5LoadBalancers') 
          else
            options.merge!('command' => 'listF5LoadBalancers')
          end
          request(options)
        end
      end

    end
  end
end

