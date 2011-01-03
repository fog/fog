for provider, config in dns_providers

  Shindo.tests("#{provider}::DNS | zones", [provider.to_s.downcase]) do

    params = {
      :domain => 'fogzonestests.com'
    }.merge!(config[:zones_params] || {})

    collection_tests(provider[:dns].zones, params, config[:mocked])

  end

end