def files_tests(connection, params = {:key => 'fog_files_tests', :body => lorem_file}, mocks_implemented = true)

  if !Fog.mocking? || mocks_implemented
    @directory = connection.directories.create(:key => 'fogfilestests')
  end

  collection_tests(@directory.files, params, mocks_implemented)

  if !Fog.mocking? || mocks_implemented
    @directory.destroy
  end

end
