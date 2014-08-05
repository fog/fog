module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists Load Balancers
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listLoadBalancers.html]
        def list_load_balancers(options={})
          options.merge!(
            'command' => 'listLoadBalancers'  
          )
          request(options)
        end
      end

    end
  end
end

