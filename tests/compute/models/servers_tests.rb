for provider, config in compute_providers

  Shindo.tests("Fog::Compute[:#{provider}] | servers", [provider]) do

    servers_tests(Fog::Compute[provider], (config[:server_attributes] || {}), config[:mocked])

  end

end
