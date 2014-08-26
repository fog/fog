module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a egress firewall rule for a given network 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createEgressFirewallRule.html]
        def create_egress_firewall_rule(options={})
          request(options)
        end


        def create_egress_firewall_rule(networkid, protocol, options={})
          options.merge!(
            'command' => 'createEgressFirewallRule', 
            'networkid' => networkid, 
            'protocol' => protocol  
          )
          request(options)
        end
      end

    end
  end
end

