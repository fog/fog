def security_group_tests(connection, params, mocks_implemented = true)
  model_tests(connection.security_groups, params[:security_group_attributes], mocks_implemented) do
    if Fog.mocking? && !mocks_implemented
      pending
    else
      responds_to(:rules)
    end
  end
end

provider, config = :cloudstack, compute_providers[:cloudstack]
Shindo.tests("Fog::Compute[:#{provider}] | security_groups", [provider.to_s]) do

  security_group_tests(Fog::Compute[:cloudstack], config, config[:mocked])

end
