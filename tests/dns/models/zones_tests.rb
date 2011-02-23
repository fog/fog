for provider, config in dns_providers

  Shindo.tests("#{provider}::DNS | zones", [provider.to_s.downcase]) do

    zone_attributes = {
      :name => 'fogzonestests.com',
      :ttl => 60
    }.merge!(config[:zone_attributes] || {})

    collection_tests(provider[:dns].zones, zone_attributes, config[:mocked])

  end

end