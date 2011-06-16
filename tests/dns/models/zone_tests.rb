for provider, config in dns_providers

  Shindo.tests("Fog::DNS[:#{provider}] | zone", [provider]) do

    zone_attributes = {
      :domain => 'fogzonetests.com'
    }.merge!(config[:zone_attributes] || {})

    model_tests(Fog::DNS[provider].zones, zone_attributes, config[:mocked])

  end

end