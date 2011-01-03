for provider, config in compute_providers

  Shindo.tests("#{provider}::Compute | servers", [provider.to_s.downcase]) do

    servers_tests(provider[:compute], (config[:server_attributes] || {}), config[:mocked])

  end

end
