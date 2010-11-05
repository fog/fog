def directory_tests(connection, mocks_implemented = true)

  tests('success') do

    if !Fog.mocking? || mocks_implemented
      @directory = connection.directories.new(:key => 'fogdirectorytests')
    end

    tests("#save").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @directory.save
    end

    tests("#destroy").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @directory.destroy
    end

    tests("#public=(true)").succeeds do
      @directory.public=(true)
    end

    tests("#respond_to?(:public_url)").succeeds do
      @directory.respond_to?(:public_url)
    end

  end

  tests('failure') do
  end

end