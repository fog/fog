for provider, config in storage_providers

  Shindo.tests("Storage[:#{provider}] | files", [provider]) do

    if !Fog.mocking? || config[:mocked]

      file_attributes = {
        :key => 'fog_files_tests',
        :body => lorem_file
      }.merge!(config[:file_attributes] || {})

      directory_attributes = {
        :key => 'fogfilestests'
      }.merge!(config[:directory_attributes] || {})

      @directory = Fog::Storage[provider].directories.create(directory_attributes)

      collection_tests(@directory.files, file_attributes, config[:mocked])

      @directory.destroy

    end

  end

end
