module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a egress firewall rule for a given network 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createEgressFirewallRule.html]
        def create_egress_firewall_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createEgressFirewallRule') 
          else
            options.merge!('command' => 'createEgressFirewallRule', 
            'networkid' => args[0], 
            'protocol' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

