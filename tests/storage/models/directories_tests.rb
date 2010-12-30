for provider, config in dns_providers

  params = {
    :key => 'fogdirectoriestests',
  }.merge!(config[:directories_params] || {})

  collection_tests(provider[:storage].directories, params, config[:mocked])

end
