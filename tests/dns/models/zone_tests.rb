for provider, config in dns_providers

  params = {
    :domain => 'fogzonetests.com'
  }.merge!(config[:zone_params] || {})

  model_tests(provider[:dns].zones, params, config[:mocked])

end