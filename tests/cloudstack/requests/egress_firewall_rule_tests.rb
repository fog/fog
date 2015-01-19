Shindo.tests('Fog::Compute[:cloudstack] | egress firewall rule requests', ['cloudstack']) do

  @egress_firewall_rules_format = {
    'listegressfirewallrulesresponse'  => {
      'count' => Integer,
      'firewallrule' => [
        'id' => String,
        'protocol' => String,
        'networkid' => String,
        'state' => String,
        'cidrlist' => String,
        'tags' => Fog::Nullable::Array
      ]
    }
  }

  tests('success') do

    tests('#list_egress_firewall_rules').formats(@egress_firewall_rules_format) do
      Fog::Compute[:cloudstack].list_egress_firewall_rules
    end

  end

end
