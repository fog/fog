module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a certificate from a Load Balancer Rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/removeCertFromLoadBalancer.html]
        def remove_cert_from_load_balancer(options={})
          request(options)
        end


        def remove_cert_from_load_balancer(lbruleid, options={})
          options.merge!(
            'command' => 'removeCertFromLoadBalancer', 
            'lbruleid' => lbruleid  
          )
          request(options)
        end
      end

    end
  end
end

