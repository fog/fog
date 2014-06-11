def security_group_rule_tests(connection, params, direction, mocks_implemented = true)
  @security_group = connection.security_groups.create(params[:security_group_attributes])

  rule_params = params[:security_group_rule_attributes].merge(:security_group_id => @security_group.id, :direction => direction)

  model_tests(connection.security_group_rules, rule_params, mocks_implemented) do

    if Fog.mocking? && !mocks_implemented
      pending
    end

  end
  @security_group.destroy
end

provider, config = :cloudstack, compute_providers[:cloudstack]

Shindo.tests("Fog::Compute[:#{provider}] | security_group_rules | ingress", [provider.to_s]) do

  security_group_rule_tests(Fog::Compute[:cloudstack], config, "ingress", config[:mocked])

end

Shindo.tests("Fog::Compute[:#{provider}] | security_group_rules | egress", [provider.to_s]) do

  security_group_rule_tests(Fog::Compute[:cloudstack], config, "egress", config[:mocked])

end
