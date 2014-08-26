module Fog
  module Compute
    class Cloudstack

      class Real
        # Updates firewall rule 
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/updateFirewallRule.html]
        def update_firewall_rule(options={})
          request(options)
        end


        def update_firewall_rule(id, options={})
          options.merge!(
            'command' => 'updateFirewallRule', 
            'id' => id  
          )
          request(options)
        end
      end

    end
  end
end

