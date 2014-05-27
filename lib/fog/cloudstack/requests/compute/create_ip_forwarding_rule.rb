module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates an ip forwarding rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createIpForwardingRule.html]
        def create_ip_forwarding_rule(options={})
          options.merge!(
            'command' => 'createIpForwardingRule', 
            'protocol' => options['protocol'], 
            'ipaddressid' => options['ipaddressid'], 
            'startport' => options['startport']  
          )
          request(options)
        end
      end

    end
  end
end

