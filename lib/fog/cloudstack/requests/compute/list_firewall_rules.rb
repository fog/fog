module Fog
  module Compute
    class Cloudstack

      class Real
        # Lists all firewall rules for an IP address.
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/listFirewallRules.html]
        def list_firewall_rules(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'listFirewallRules') 
          else
            options.merge!('command' => 'listFirewallRules')
          end
          request(options)
        end
      end

    end
  end
end

