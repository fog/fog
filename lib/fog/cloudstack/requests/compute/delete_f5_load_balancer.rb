module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a F5 load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteF5LoadBalancer.html]
        def delete_f5_load_balancer(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteF5LoadBalancer') 
          else
            options.merge!('command' => 'deleteF5LoadBalancer', 
            'lbdeviceid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

