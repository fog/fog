Shindo.tests('Fog::Google[:sql] | operation model', ['google']) do
  @instance = Fog::Google[:sql].instances.create(:instance => Fog::Mock.random_letters(16), :tier => 'D1')
  @instance.wait_for { ready? }
  @operations = Fog::Google[:sql].operations
  @operation = @operations.all(@instance.instance).first

  tests('success') do

    tests('#pending?').succeeds do
      @operation.pending? == false
    end

    tests('#ready?').succeeds do
      @operation.ready? == true
    end

    tests('#reload').succeeds do
      @operation.reload
    end

  end

  @instance.destroy

end
