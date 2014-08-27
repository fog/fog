module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all egress firewall rules for network id.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listEgressFirewallRules.html]
        def list_egress_firewall_rules(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listEgressFirewallRules') 
          else
            options.merge!('command' => 'listEgressFirewallRules')
          end
          request(options)
        end
      end

    end
  end
end

