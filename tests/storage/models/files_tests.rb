for provider, config in storage_providers

  Shindo.tests("#{provider}::Storage | files", [provider.to_s.downcase]) do

    attributes = {
      :key => 'fog_files_tests',
      :body => lorem_file
    }.merge!(config[:files_attributes] || {})

    if !Fog.mocking? || config[:mocked]

      @directory = provider.directories.create(:key => 'fogfilestests')

      collection_tests(@directory.files, attributes, config[:mocked])

      @directory.destroy

    end

  end

end
