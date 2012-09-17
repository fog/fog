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

  tests('Fog::Mock.dump').returns(Fog::Mock.mocked_services_with_data.map(&:to_s).sort, "hash with one entry per mocked service") do
    Fog.mock!
    Fog::Mock.dump.keys.sort
  end

  tests('Fog::Mock.restore reload internal mock data from dump').returns(false) do
    Fog.mock!
    id = Fog::Compute.new(:provider => 'aws').servers.create.identity
    dump = Fog::Mock.dump
    Fog::Mock.reset
    Fog::Mock.restore(dump)
    Fog::Compute.new(:provider => 'aws').servers.get(id).nil?
  end

  tests('Fog::Mock.dump/restore supports YAML serialization').returns(false) do
    Fog.mock!
    id = Fog::Compute.new(:provider => 'aws').servers.create.identity
    d = YAML.dump(Fog::Mock.dump)
    Fog::Mock.reset
    Fog::Mock.restore(YAML.load(d))
    Fog::Compute.new(:provider => 'aws').servers.get(id).nil?
  end

end
