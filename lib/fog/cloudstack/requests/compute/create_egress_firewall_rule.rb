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

      class Mock
        def create_egress_firewall_rule(*args)
          egress_firewall_rule_id = Fog::Cloudstack.uuid

          egress_firewall_rule = {
            "id" => egress_firewall_rule_id,
            "protocol" => "tcp",
            "networkid" => "f1f1f1-f1f1-f1f1f1-f1f1f1f1f1",
            "state" => "Active",
            "cidrlist" => "10.2.1.0/24",
          }

          self.data[:egress_firewall_rules][egress_firewall_rule_id] = egress_firewall_rule

          {'createegressfirewallruleresponse' => egress_firewall_rule}
        end
      end

    end
  end
end

