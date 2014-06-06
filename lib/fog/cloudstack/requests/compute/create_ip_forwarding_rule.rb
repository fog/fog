module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an ip forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createIpForwardingRule.html]
        def create_ip_forwarding_rule(startport, protocol, ipaddressid, options={})
          options.merge!(
            'command' => 'createIpForwardingRule', 
            'startport' => startport, 
            'protocol' => protocol, 
            'ipaddressid' => ipaddressid  
          )
          request(options)
        end
      end

    end
  end
end

