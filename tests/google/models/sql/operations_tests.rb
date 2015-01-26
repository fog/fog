Shindo.tests('Fog::Google[:sql] | operations model', ['google']) do
  @instance = Fog::Google[:sql].instances.create(:instance => Fog::Mock.random_letters(16), :tier => 'D1')
  @instance.wait_for { ready? }
  @operations = Fog::Google[:sql].operations

  tests('success') do

    tests('#all').succeeds do
      @operations.all(@instance.instance)
    end

    tests('#get').succeeds do
      @operations.get(@instance.instance, @operations.all(@instance.instance).first.operation)
    end

  end

  tests('failure') do

    tests('#all').returns([]) do
      @operations.all(Fog::Mock.random_letters_and_numbers(16))
    end

    tests('#get').returns(nil) do
      pending unless Fog.mocking? # Real test fails on google-api-client (mismatch between catalog and real response)
      @operations.get(@instance.instance, Fog::Mock.random_letters_and_numbers(16))
    end

    tests('#get').returns(nil) do
      pending unless Fog.mocking? # Real test fails on google-api-client (mismatch between catalog and real response)
      @operations.get(Fog::Mock.random_letters_and_numbers(16), Fog::Mock.random_letters_and_numbers(16))
    end

  end

  @instance.destroy

end
