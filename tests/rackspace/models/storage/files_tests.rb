Shindo.tests("Fog::Rackspace::Storage | files", ['rackspace', 'storage']) do

  file_attributes = {
    :key => 'fog_files_tests',
    :body => lorem_file
  }

  directory_attributes = {
    :key => 'fogfilestests',
    :public => true
  }

  tests('success') do
    collection_tests(Fog::Storage[:rackspace].directories.create(directory_attributes).files, file_attributes, Fog.mocking?)

    @service = Fog::Storage.new :provider => 'rackspace', :rackspace_temp_url_key => "my_secret"

    @directory = @service.directories.create(directory_attributes)
    @file = @directory.files.create(file_attributes)

    tests("#get_url('#{@directory.key}')").succeeds do
      @directory.files.get_url(@directory.key)
    end

    tests("#get_http_url('#{@directory.key}')").succeeds do
      expire_time = Time.now + 3600
      @directory.files.get_http_url(@file.key, expire_time)
    end

    tests("#get_https_url('#{@directory.key}', '#{@file.key}')").succeeds do
      expire_time = Time.now + 3600
      @directory.files.get_https_url(@file.key, expire_time)
    end

    @file.destroy
    @directory.destroy
  end

end
