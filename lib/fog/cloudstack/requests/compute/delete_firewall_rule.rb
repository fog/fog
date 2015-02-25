module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes a firewall rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteFirewallRule.html]
        def delete_firewall_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteFirewallRule')
          else
            options.merge!('command' => 'deleteFirewallRule',
            'id' => args[0])
          end
          request(options)
        end
      end

      class Mock
        def delete_firewall_rule(options={})
          firewall_rule_id = options['id']
          data[:firewall_rules].delete(firewall_rule_id) if data[:firewall_rules][firewall_rule_id]

          { 'deletefirewallruleresponse' => { 'success' => 'true' } }
        end
      end

    end
  end
end

