Shindo.tests("Fog::Storage[:hp] | directory", ['hp', 'storage']) do

  file_attributes = {
    :key => 'fog_file_tests',
    :body => lorem_file,
    :public => true
  }

  directory_attributes = {
    :key => 'fogfilestests'
  }

  @directory = Fog::Storage[:hp].directories.create(directory_attributes)

  model_tests(@directory.files, file_attributes, true) do

    @file = @directory.files.get('fog_file_tests')

    tests('success') do

      tests("#directory").returns(@directory.key) do
        @file.directory.key
      end

      tests("#cdn_public_url").succeeds do
        pending if Fog.mocking?
        @file.cdn_public_url
      end

      tests("#cdn_public_ssl_url").succeeds do
        pending if Fog.mocking?
        @file.cdn_public_ssl_url
      end

      tests("#temp_signed_url(60, 'GET')").succeeds do
        @file.temp_signed_url(60, 'GET')
      end

    end
  end

  @directory.destroy

end
