Shindo.tests('Fog mocking', 'core') do
  before do
    @fog_was_mocked = Fog.mock?
    Fog.unmock! if @fog_was_mocked
  end

  after do
    Fog.mock! if @fog_was_mocked
  end

  tests('Fog.mock!') do
    tests('Fog.mock!').returns(true) do
      Fog.mock!
    end

    tests('Fog.mock? without Fog.mock!').returns(false) do
      Fog.mock?
    end

    tests('Fog.mock? with Fog.mock!').returns(true) do
      Fog.mock!
      Fog.mock?
    end

    tests('Fog.mocking? without Fog.mock!').returns(false) do
      Fog.mocking?
    end

    tests('Fog.mocking? with Fog.mock!').returns(true) do
      Fog.mock!
      Fog.mocking?
    end
  end

  tests('Fog::Mock.delay') do
    tests('Fog::Mock.delay').returns(1, "defaults to 1") do
      Fog::Mock.delay
    end

    tests('Fog::Mock.delay = 2').returns(2, "changes Fog::Mock.delay to 2") do
      Fog::Mock.delay = 2
      Fog::Mock.delay
    end

    tests('Fog::Mock.delay = 0').returns(0, "changes Fog::Mock.delay to 0") do
      Fog::Mock.delay = 0
      Fog::Mock.delay
    end

    tests('Fog::Mock.delay = -1').raises(ArgumentError) do
      Fog::Mock.delay = -1
    end
  end

  tests('Fog::Mock.not_implemented').raises(Fog::Errors::MockNotImplemented) do
    Fog::Mock.not_implemented
  end

  
end
