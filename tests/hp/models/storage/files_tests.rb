Shindo.tests("Fog::Storage[:hp] | files", ['hp', 'storage']) do

  file_attributes = {
    :key => 'fog_files_tests',
    :body => lorem_file
  }

  directory_attributes = {
    :key => 'fogfilestests'
  }

  collection_tests(Fog::Storage[:hp].directories.create(directory_attributes).files, file_attributes, true)

  @directory = Fog::Storage[:hp].directories.create(directory_attributes)
  @file = @directory.files.create(file_attributes)

  tests('success') do

    tests("#get_url('#{@directory.key}')").succeeds do
      @directory.files.get_url(@directory.key)
    end

    tests("#get_cdn_url('#{@directory.key}')").succeeds do
      pending if Fog.mocking?
      @directory.files.get_cdn_url(@directory.key)
    end

    tests("#get_cdn_ssl_url('#{@directory.key}')").succeeds do
      pending if Fog.mocking?
      @directory.files.get_cdn_ssl_url(@directory.key)
    end

  end

  @file.destroy
  @directory.destroy

end
