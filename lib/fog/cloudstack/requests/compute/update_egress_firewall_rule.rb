module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates egress firewall rule 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateEgressFirewallRule.html]
        def update_egress_firewall_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateEgressFirewallRule') 
          else
            options.merge!('command' => 'updateEgressFirewallRule', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

