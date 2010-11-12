def server_tests(connection, params = {}, mocks_implemented = true)

  model_tests(connection.servers, params, mocks_implemented) do

    responds_to([:ready?, :state])

    tests('#reboot').succeeds do
      @instance.wait_for { ready? }
      @instance.reboot
    end

    @instance.wait_for { ready? }

  end

end
