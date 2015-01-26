Shindo.tests('Fog::Compute[:cloudstack] | firewall rule requests', ['cloudstack']) do

  @firewall_rules_format = {
    'listfirewallrulesresponse'  => {
      'count' => Integer,
      'firewallrule' => [
        'id' => String,
        'protocol' => String,
        'startport' => String,
        'endport' => String,
        'ipaddressid' => String,
        'networkid' => String,
        'ipaddress' => String,
        'state' => String,
        'cidrlist' => String,
        'tags' => Fog::Nullable::Array
      ]
    }
  }

  tests('success') do

    tests('#list_firewall_rules').formats(@firewall_rules_format) do
      Fog::Compute[:cloudstack].list_firewall_rules
    end

  end

end
