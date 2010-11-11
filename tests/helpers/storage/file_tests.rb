def file_tests(connection, params = {:key => 'fog_file_tests', :body => lorem_file}, mocks_implemented = true)

  if !Fog.mocking? || mocks_implemented
    @directory = connection.directories.create(:key => 'fogfilestests')
  end

  model_tests(@directory.files, params, mocks_implemented) do

    tests("#respond_to?(:public_url)").succeeds do
      @instance.respond_to?(:public_url)
    end

  end

  if !Fog.mocking? || mocks_implemented
    @directory.destroy
  end

end
