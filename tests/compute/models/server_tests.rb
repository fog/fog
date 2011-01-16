for provider, config in compute_providers

  Shindo.tests("#{provider}::Compute | server", [provider.to_s.downcase]) do

    server_tests(provider[:compute], (config[:server_attributes] || {}), config[:mocked])

  end

end
