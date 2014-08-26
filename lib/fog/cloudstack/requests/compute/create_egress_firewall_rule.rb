module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a egress firewall rule for a given network 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createEgressFirewallRule.html]
        def create_egress_firewall_rule(protocol, networkid, options={})
          options.merge!(
            'command' => 'createEgressFirewallRule', 
            'protocol' => protocol, 
            'networkid' => networkid  
          )
          request(options)
        end
      end

    end
  end
end

