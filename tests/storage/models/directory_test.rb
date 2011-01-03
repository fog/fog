for provider, config in storage_providers

  Shindo.tests("#{provider}::Storage | directory", [provider.to_s.downcase]) do

    params = {
      :key => 'fogdirectorytests'
    }.merge!(config[:directory_params] || {})

    model_tests(provider[:storage].directory, params, config[:mocked]) do

      tests("#public=(true)").succeeds do
        pending if Fog.mocking? && !config[:mocked]
        @instance.public=(true)
      end

      if !Fog.mocking? || config[:mocked]
        @instance.responds_to(:public_url)
      end

    end

  end

end
