module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all firewall rules for an IP address.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/listFirewallRules.html]
        def list_firewall_rules(options={})
          options.merge!(
            'command' => 'listFirewallRules'  
          )
          request(options)
        end
      end

    end
  end
end

