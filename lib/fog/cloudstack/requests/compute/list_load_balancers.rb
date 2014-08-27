module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists Load Balancers
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listLoadBalancers.html]
        def list_load_balancers(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listLoadBalancers') 
          else
            options.merge!('command' => 'listLoadBalancers')
          end
          request(options)
        end
      end

    end
  end
end

