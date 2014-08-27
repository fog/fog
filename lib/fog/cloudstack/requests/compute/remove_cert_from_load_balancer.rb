module Fog
  module Compute
    class Cloudstack

      class Real
        # Removes a certificate from a Load Balancer Rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/removeCertFromLoadBalancer.html]
        def remove_cert_from_load_balancer(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'removeCertFromLoadBalancer') 
          else
            options.merge!('command' => 'removeCertFromLoadBalancer', 
            'lbruleid' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

