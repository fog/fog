for provider, config in dns_providers

  Shindo.tests("#{provider}::DNS | zone", [provider.to_s.downcase]) do

    params = {
      :domain => 'fogzonetests.com'
    }.merge!(config[:zone_params] || {})

    model_tests(provider[:dns].zones, params, config[:mocked])

  end

end