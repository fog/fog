for provider, config in storage_providers

  Shindo.tests("Storage[:#{provider}] | directory", [provider.to_s]) do

    if !Fog.mocking? || config[:mocked]

      directory_attributes = {
        :key => 'fogdirectorytests'
      }.merge!(config[:directory_attributes] || {})

      model_tests(Fog::Storage[provider].directories, directory_attributes, config[:mocked]) do

        tests("#public=(true)").succeeds do
          pending if Fog.mocking? && !config[:mocked]
          @instance.public=(true)
        end

        tests('responds_to(:public_url)') do
          pending if Fog.mocking? && !config[:mocked]
          responds_to(:public_url)
        end

      end

    end

  end

end
