for provider, config in dns_providers

  params = {
    :key => 'fog_files_tests',
    :body => lorem_file
  }.merge!(config[:files_params] || {})

  if !Fog.mocking? || mocks_implemented

    @directory = provider.directories.create(:key => 'fogfilestests')

    collection_tests(@directory.files, params, config[:mocked])

    @directory.destroy

  end

end
