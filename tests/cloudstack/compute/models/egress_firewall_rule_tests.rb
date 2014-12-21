Shindo.tests("Fog::Compute[:cloudstack] | egress_firewall_rule", "cloudstack") do
  config = compute_providers[:cloudstack]
  compute = Fog::Compute[:cloudstack]

  model_tests(compute.egress_firewall_rules, config[:egress_firewall_rule_attributes], config[:mocked])
end
