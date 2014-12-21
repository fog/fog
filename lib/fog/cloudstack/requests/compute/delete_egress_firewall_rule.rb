module Fog
  module Compute
    class Cloudstack

      class Real
        # Deletes an ggress firewall rule
        #
        # {CloudStack API Reference}[http://cloudstack.apache.org/docs/api/apidocs-4.4/root_admin/deleteEgressFirewallRule.html]
        def delete_egress_firewall_rule(*args)
          options = {}
          if args[0].is_a? Hash
            options = args[0]
            options.merge!('command' => 'deleteEgressFirewallRule')
          else
            options.merge!('command' => 'deleteEgressFirewallRule',
            'id' => args[0])
          end
          request(options)
        end
      end

      class Mock
        def delete_egress_firewall_rule(options={})
          egress_firewall_rule_id = options['id']
          data[:egress_firewall_rules].delete(egress_firewall_rule_id) if data[:egress_firewall_rules][egress_firewall_rule_id]

          { 'deleteegressfirewallruleresponse' => { 'success' => 'true' } }
        end
      end

    end
  end
end

