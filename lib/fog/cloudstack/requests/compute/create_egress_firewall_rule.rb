module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a egress firewall rule for a given network 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/createEgressFirewallRule.html]
        def create_egress_firewall_rule(options={})
          options.merge!(
            'command' => 'createEgressFirewallRule', 
            'networkid' => options['networkid'], 
            'protocol' => options['protocol']  
          )
          request(options)
        end
      end

    end
  end
end

