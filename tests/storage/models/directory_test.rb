for provider, config in dns_providers

  params = {
    :key => 'fogdirectorytests'
  }.merge!(config[:directory_params] || {})

  model_tests(provider[:storage].directory, params, config[:mocked]) do

    tests("#public=(true)").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @instance.public=(true)
    end

    if !Fog.mocking? || mocks_implemented
      @instance.responds_to(:public_url)
    end

  end

end
