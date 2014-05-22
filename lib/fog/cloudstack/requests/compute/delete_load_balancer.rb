module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a load balancer
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteLoadBalancer.html]
        def delete_load_balancer(options={})
          options.merge!(
            'command' => 'deleteLoadBalancer',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

