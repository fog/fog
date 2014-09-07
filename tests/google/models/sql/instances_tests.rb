Shindo.tests('Fog::Google[:sql] | instances model', ['google']) do
  @instance = Fog::Google[:sql].instances.create(:instance => Fog::Mock.random_letters(16), :tier => 'D1')
  @instance.wait_for { ready? }
  @instances = Fog::Google[:sql].instances

  tests('success') do

    tests('#all').succeeds do
      @instances.all
    end

    tests('#get').succeeds do
      @instances.get(@instance.instance)
    end

  end

  @instance.destroy(:async => false)

  tests('failure') do

    tests('#all').returns([]) do
      @instances.all
    end

    tests('#get').returns(nil) do
      @instances.get(Fog::Mock.random_letters_and_numbers(16))
    end

  end

end
