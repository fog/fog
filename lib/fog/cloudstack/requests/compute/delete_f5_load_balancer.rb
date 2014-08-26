module Fog
  module Compute
    class Cloudstack

      class Real
        #  delete a F5 load balancer device
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteF5LoadBalancer.html]
        def delete_f5_load_balancer(lbdeviceid, options={})
          options.merge!(
            'command' => 'deleteF5LoadBalancer', 
            'lbdeviceid' => lbdeviceid  
          )
          request(options)
        end
      end

    end
  end
end

