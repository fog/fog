for provider, config in storage_providers

  Shindo.tests("#{provider}::Storage | directories", [provider.to_s.downcase]) do

    params = {
      :key => 'fogdirectoriestests',
    }.merge!(config[:directories_params] || {})

    collection_tests(provider[:storage].directories, params, config[:mocked])

  end

end