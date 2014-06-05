for provider, config in storage_providers

  Shindo.tests("Storage[:#{provider}] | directories", [provider.to_s]) do

    if !Fog.mocking? || config[:mocked]

      directory_attributes = {
        :key => 'fogdirectoriestests',
      }.merge!(config[:directory_attributes] || {})

      collection_tests(Fog::Storage[provider].directories, directory_attributes, config[:mocked])

    end

  end

end
