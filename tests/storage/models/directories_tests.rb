for provider, config in storage_providers

  Shindo.tests("#{provider}::Storage | directories", [provider.to_s.downcase]) do

    directory_attributes = {
      :key => 'fogdirectoriestests',
    }.merge!(config[:directory_attributes] || {})

    collection_tests(provider[:storage].directories, directory_attributes, config[:mocked])

  end

end