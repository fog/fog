for provider, config in storage_providers

  Shindo.tests("#{provider}::Storage | file", [provider.to_s.downcase]) do

    params = {
      :key => 'fog_file_tests',
      :body => lorem_file,
      :public => true
    }.merge!(config[:directory_params] || {})

    if !Fog.mocking? || config[:mocked]

      @directory = provider[:storage].directories.create(:key => 'fogfilestests')

      model_tests(@directory.files, params, config[:mocked]) do

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
