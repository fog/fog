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

      class Mock
        def create_firewall_rule(options={})
          firewall_rule_id = Fog::Cloudstack.uuid

          firewall_rule = {
            "id"              => network_offering_id,
            "protocol"        => "tcp",
            "startport"       => 80,
            "endport"         => 80,
            "ipaddressid"     => "f1f1f1f1-f1f1-f1f1-f1f1f1f1f1f1",
            "networkid"       => "f1f1f1f1-f1f1-f1f1-f1f1f1f1f1f1",
            "ipaddress"       => "10.1.1.253",
            "state"           => "Active",
            "cidrlist"        => "255.255.255.0/24"
          }

          self.data[:firewall_rules][firewall_rule_id] = firewall_ruleetwork_offering

          {'createfirewallruleresponse' => firewall_rule}
        end
      end

    end
  end
end

