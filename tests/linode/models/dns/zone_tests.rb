Shindo.tests('Linode::DNS | zone model', ['linode']) do

  zone_tests(Linode[:dns], {}, false) do

    if !Fog.mocking? || mocks_implemented
      @instance.responds_to(:nameservers)
    end

  end

end
