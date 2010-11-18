def file_tests(connection, params = {}, mocks_implemented = true)

  params = {:key => 'fog_file_tests', :body => lorem_file}.merge!(params)

  if !Fog.mocking? || mocks_implemented
    @directory = connection.directories.create(:key => 'fogfilestests')

    model_tests(@directory.files, params, mocks_implemented) do

      tests("#public=(true)").succeeds do
        pending if Fog.mocking? && !mocks_implemented
        @instance.public=(true)
      end

      tests("#respond_to?(:public_url)").succeeds do
        @instance.respond_to?(:public_url)
      end

    end

    @directory.destroy
  end

end
