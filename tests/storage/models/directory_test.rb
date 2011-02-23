for provider, config in storage_providers

  Shindo.tests("#{provider}::Storage | directory", [provider.to_s.downcase]) do

    directory_attributes = {
      :key => 'fogdirectorytests'
    }.merge!(config[:directory_attributes] || {})

    model_tests(provider[:storage].directory, directory_attributes, config[:mocked]) do

      tests("#public=(true)").succeeds do
        pending if Fog.mocking? && !config[:mocked]
        @instance.public=(true)
      end

      tests('responds_to(:public_url)') do
        pending if Fog.mocking? && !config[:mocked]
        @instance.responds_to(:public_url)
      end

    end

  end

end
