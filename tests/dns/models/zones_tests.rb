for provider, config in dns_providers

  Shindo.tests("Fog::DNS[:#{provider}] | zones", [provider]) do

    zone_attributes = {
      :domain => 'fogzonestests.com'
    }.merge!(config[:zone_attributes] || {})

    collection_tests(Fog::DNS[provider].zones, zone_attributes, config[:mocked])

  end

end