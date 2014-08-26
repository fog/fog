module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates egress firewall rule 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateEgressFirewallRule.html]
        def update_egress_firewall_rule(options={})
          request(options)
        end


        def update_egress_firewall_rule(id, options={})
          options.merge!(
            'command' => 'updateEgressFirewallRule', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

