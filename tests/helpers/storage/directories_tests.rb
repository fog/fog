def directories_tests(connection, mocks_implemented = true)

  tests('success') do

    tests("#new(:key => 'fogdirectoriestests')").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @directory = connection.directories.new(:key => 'fogdirectoriestests')
    end

    tests("#create(:key => 'fogdirectoriestests')").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @directory = connection.directories.create(:key => 'fogdirectoriestests')
    end

    tests("#all").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      connection.directories.all
    end

    tests("#get('fogdirectoriestests')").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      connection.directories.get('fogdirectoriestests')
    end

    if !Fog.mocking? || mocks_implemented
      @directory.destroy
    end
  end

  tests('failure') do

    tests("#get('fognondirectory')").returns(nil) do
      pending if Fog.mocking? && !mocks_implemented
      connection.directories.get('fognondirectory')
    end

  end

end