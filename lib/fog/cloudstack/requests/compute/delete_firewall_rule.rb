module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a firewall rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.3/root_admin/deleteFirewallRule.html]
        def delete_firewall_rule(options={})
          options.merge!(
            'command' => 'deleteFirewallRule',
            'id' => options['id'], 
             
          )
          request(options)
        end
      end

    end
  end
end

