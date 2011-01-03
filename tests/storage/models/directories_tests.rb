for provider, config in storage_providers

  Shindo.tests("#{provider}::Storage | directories", [provider.to_s.downcase]) do

    attributes = {
      :key => 'fogdirectoriestests',
    }.merge!(config[:directories_attributes] || {})

    collection_tests(provider[:storage].directories, attributes, config[:mocked])

  end

end