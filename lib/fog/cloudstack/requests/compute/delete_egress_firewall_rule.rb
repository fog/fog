module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an ggress firewall rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteEgressFirewallRule.html]
        def delete_egress_firewall_rule(id, options={})
          options.merge!(
            'command' => 'deleteEgressFirewallRule', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

