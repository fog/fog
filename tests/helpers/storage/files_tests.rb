def files_tests(connection, mocks_implemented = true)

  if !Fog.mocking? || mocks_implemented
    @directory = connection.directories.create(:key => 'fogfilestests')
  end

  tests('success') do

    tests("#new(:key => 'fog_files_tests', :body => lorem_file)").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @directory.files.new(:key => 'fog_files_tests', :body => lorem_file)
    end

    tests("#create(:key => 'fog_files_tests', :body => lorem_file)").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @file = @directory.files.create(:key => 'fog_files_tests', :body => lorem_file)
    end

    tests("#all").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @directory.files.all
    end

    tests("#get('fog_files_tests')").succeeds do
      pending if Fog.mocking? && !mocks_implemented
      @directory.files.get('fog_files_tests')
    end

    if !Fog.mocking? || mocks_implemented
      @file.destroy
    end
  end

  tests('failure') do

    tests("#get('fog_non_file')").returns(nil) do
      pending if Fog.mocking? && !mocks_implemented
      @directory.files.get('fog_non_file')
    end

  end

  if !Fog.mocking? || mocks_implemented
    @directory.destroy
  end

end