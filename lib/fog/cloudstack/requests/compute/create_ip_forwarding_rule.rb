module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an ip forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createIpForwardingRule.html]
        def create_ip_forwarding_rule(options={})
          request(options)
        end


        def create_ip_forwarding_rule(ipaddressid, protocol, startport, options={})
          options.merge!(
            'command' => 'createIpForwardingRule', 
            'ipaddressid' => ipaddressid, 
            'protocol' => protocol, 
            'startport' => startport  
          )
          request(options)
        end
      end

    end
  end
end

