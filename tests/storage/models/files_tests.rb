for provider, config in storage_providers

  Shindo.tests("#{provider}::Storage | files", [provider.to_s.downcase]) do

    params = {
      :key => 'fog_files_tests',
      :body => lorem_file
    }.merge!(config[:files_params] || {})

    if !Fog.mocking? || config[:mocked]

      @directory = provider.directories.create(:key => 'fogfilestests')

      collection_tests(@directory.files, params, config[:mocked])

      @directory.destroy

    end

  end

end
