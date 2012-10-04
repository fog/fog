Shindo.tests('Fog::Storage[:hp] | files', ['hp', 'storage']) do

  file_attributes = {
    :key => 'fog_files_tests',
    :body => lorem_file
  }

  directory_attributes = {
    :key => 'fogfilestests'
  }

  @directory = Fog::Storage[:hp].directories.create(directory_attributes)

  collection_tests(@directory.files, file_attributes, true) do

    tests('success') do

      tests("#get_url('#{@directory.key}')").succeeds do
        @directory.files.get_url("#{@directory.key}")
      end

      tests("#get_cdn_url('#{@directory.key}')").succeeds do
        pending if Fog.mocking?
        @directory.files.get_cdn_url("#{@directory.key}")
      end

      tests("#get_cdn_ssl_url('#{@directory.key}')").succeeds do
        pending if Fog.mocking?
        @directory.files.get_cdn_ssl_url("#{@directory.key}")
      end

      tests("#head('#{@directory.key}')").succeeds do
        @directory.files.head("#{@directory.key}")
      end

    end

  end

  @directory.destroy

end