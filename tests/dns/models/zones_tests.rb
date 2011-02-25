for provider, config in dns_providers

  Shindo.tests("#{provider}::DNS | zones", [provider.to_s.downcase]) do

    zone_attributes = {
      :domain => 'fogzonestests.com'
    }.merge!(config[:zone_attributes] || {})

    collection_tests(provider[:dns].zones, zone_attributes, config[:mocked])

  end

end