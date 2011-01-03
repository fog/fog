for provider, config in dns_providers

  Shindo.tests("#{provider}::DNS | zones", [provider.to_s.downcase]) do

    attributes = {
      :domain => 'fogzonestests.com'
    }.merge!(config[:zones_attributes] || {})

    collection_tests(provider[:dns].zones, attributes, config[:mocked])

  end

end