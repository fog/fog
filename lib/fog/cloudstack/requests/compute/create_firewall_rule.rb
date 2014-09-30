module Fog
  module Compute
    class Cloudstack

      class Real
        # Creates a firewall rule for a given ip address
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/createFirewallRule.html]
        def create_firewall_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'createFirewallRule') 
          else
            options.merge!('command' => 'createFirewallRule', 
            'ipaddressid' => args[0], 
            'protocol' => args[1])
          end
          request(options)
        end
      end

    end
  end
end

