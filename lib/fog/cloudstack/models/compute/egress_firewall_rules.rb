require 'fog/core/collection'
require 'fog/cloudstack/models/compute/egress_firewall_rule'

module Fog
  module Compute
    class Cloudstack
      class EgressFirewallRules < Fog::Collection
        model Fog::Compute::Cloudstack::EgressFirewallRule

        def all(options = {})
          response = service.list_egress_firewall_rules(options)
          egress_firewall_rules = response["listegressfirewallrulesresponse"]["firewallrule"] || []
          load(egress_firewall_rules)
        end

        def get(address_id)
          options = { 'id' => address_id }
          response = service.list_egress_firewall_rules(options)
          egress_firewall_rules = response["listegressfirewallrulesresponse"]["firewallrule"].first
          new(egress_firewall_rules)
        end
      end
    end
  end
end
