module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates firewall rule 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/updateFirewallRule.html]
        def update_firewall_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'updateFirewallRule') 
          else
            options.merge!('command' => 'updateFirewallRule', 
            'id' => args[0])
          end
          request(options)
        end
      end

    end
  end
end

