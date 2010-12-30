for provider, config in dns_providers

  params = {
    :domain => 'fogzonestests.com'
  }.merge!(config[:zones_params] || {})

  collection_tests(provider[:dns].zones, params, config[:mocked])

end
