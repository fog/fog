for provider, config in dns_providers

  Shindo.tests("#{provider}::DNS | zone", [provider.to_s.downcase]) do

    zone_attributes = {
      :domain => 'fogzonetests.com'
    }.merge!(config[:zone_attributes] || {})

    model_tests(provider[:dns].zones, zone_attributes, config[:mocked])

  end

end