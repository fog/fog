for provider, config in storage_providers

  Shindo.tests("Storage[:#{provider}] | file", [provider]) do

    if !Fog.mocking? || config[:mocked]

      file_attributes = {
        :key => 'fog_file_tests',
        :body => lorem_file,
        :public => true
      }.merge!(config[:file_attributes] || {})

      directory_attributes = {
        :key => 'fogfilestests'
      }.merge!(config[:directory_attributes] || {})

      @directory = Fog::Storage[provider].directories.create(directory_attributes)

      model_tests(@directory.files, file_attributes, config[:mocked]) do

        responds_to(:public_url)

        tests("#public=(true)").succeeds do
          pending if Fog.mocking? && !config[:mocked]
          @instance.public=(true)
        end

        test("@instance.public_url.nil? || Excon.get(@instance.public_url).body == lorem_file.read") do
          pending if Fog.mocking?
          @instance.public_url.nil? || Excon.get(@instance.public_url).body == lorem_file.read
        end

      end

      @directory.destroy

    end

  end

end
