for provider, config in storage_providers

  Shindo.tests("#{provider}::Storage | files", [provider.to_s.downcase]) do

    file_attributes = {
      :key => 'fog_files_tests',
      :body => lorem_file
    }.merge!(config[:file_attributes] || {})

    if !Fog.mocking? || config[:mocked]

      directory_attributes = {
        :key => 'fogfilestests'
      }.merge!(config[:directory_attributes] || {})

      @directory = provider.directories.create(directory_attributes)

      collection_tests(@directory.files, file_attributes, config[:mocked])

      @directory.destroy

    end

  end

end
