Shindo.tests('Fog::Google[:sql] | ssl_cert model', ['google']) do
  @instance = Fog::Google[:sql].instances.create(:instance => Fog::Mock.random_letters(16), :tier => 'D1')
  @instance.wait_for { ready? }
  @ssl_certs = Fog::Google[:sql].ssl_certs

  tests('success') do

    tests('#create').succeeds do
      @ssl_cert = @ssl_certs.create(:instance => @instance.instance, :common_name => Fog::Mock.random_letters(16))
    end

    tests('#reload').succeeds do
      @ssl_cert.reload
    end

    tests('#destroy').succeeds do
      @ssl_cert.destroy
    end

  end

  @instance.destroy

end
