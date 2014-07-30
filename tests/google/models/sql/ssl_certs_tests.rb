Shindo.tests('Fog::Google[:sql] | ssl_certs model', ['google']) do
  @instance = Fog::Google[:sql].instances.create(:instance => Fog::Mock.random_letters(16), :tier => 'D1')
  @instance.wait_for { ready? }
  @ssl_cert = Fog::Google[:sql].ssl_certs.create(:instance => @instance.instance,
                                                 :common_name => Fog::Mock.random_letters(16))
  @ssl_certs = Fog::Google[:sql].ssl_certs

  tests('success') do

    tests('#all').succeeds do
      @ssl_certs.all(@instance.instance)
    end

    tests('#get').succeeds do
      @ssl_certs.get(@instance.instance, @ssl_cert.sha1_fingerprint)
    end

  end

  tests('failure') do

    tests('#all').returns([]) do
      @ssl_certs.all(Fog::Mock.random_letters_and_numbers(16))
    end

    tests('#get').returns(nil) do
      @ssl_certs.get(@instance.instance, Fog::Mock.random_letters_and_numbers(16))
    end

    tests('#get').returns(nil) do
      @ssl_certs.get(Fog::Mock.random_letters_and_numbers(16), Fog::Mock.random_letters_and_numbers(16))
    end

  end

  @ssl_cert.destroy
  @instance.destroy

end
