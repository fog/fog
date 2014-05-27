module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all egress firewall rules for network id.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listEgressFirewallRules.html]
        def list_egress_firewall_rules(options={})
          options.merge!(
            'command' => 'listEgressFirewallRules'  
          )
          request(options)
        end
      end

    end
  end
end

