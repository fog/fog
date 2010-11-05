def file_tests(connection, mocks_implemented = true)

  if !Fog.mocking? || mocks_implemented
    @directory = connection.directories.create(:key => 'fogfilestests')
  end

  tests('success') do

    if !Fog.mocking? || mocks_implemented
      @file = @directory.files.new(:key => 'fog_file_tests', :body => lorem_file)
    end

    tests("#save").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @file.save
    end

    tests("#destroy").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @file.destroy
    end

    tests("#respond_to?(:public_url)").succeeds do
      @directory.respond_to?(:public_url)
    end

  end

  tests('failure') do
  end

  if !Fog.mocking? || mocks_implemented
    @directory.destroy
  end

end