def directory_tests(connection, params = {:key => 'fogdirectorytests'}, mocks_implemented = true)

  model_tests(connection.directories, params, mocks_implemented) do

    tests("#public=(true)").succeeds do
      @instance.public=(true)
    end

    tests("#respond_to?(:public_url)").succeeds do
      @instance.respond_to?(:public_url)
    end

  end

end
