module Fog
  module Compute
    class Cloudstack

      class Real
        # Assigns a certificate to a Load Balancer Rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/assignCertToLoadBalancer.html]
        def assign_cert_to_load_balancer(options={})
          request(options)
        end


        def assign_cert_to_load_balancer(lbruleid, certid, options={})
          options.merge!(
            'command' => 'assignCertToLoadBalancer', 
            'lbruleid' => lbruleid, 
            'certid' => certid  
          )
          request(options)
        end
      end

    end
  end
end

