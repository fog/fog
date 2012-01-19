Fog.mock!

Shindo.tests("Storage[:aws] | file", [:aws]) do

  file_attributes = {
    :key => 'fog_file_tests',
    :body => lorem_file,
    :public => true
  }

  directory_attributes = {
    :key => 'fogfilestests'
  }

  @directory = Fog::Storage[:aws].directories.create(directory_attributes)

  model_tests(@directory.files, file_attributes, Fog.mocking?) do

    tests("#version") do
      tests("#version should be null if versioning isn't enabled").returns(nil) do
        @instance.version
      end
    end

  end

  @directory.versioning = true

  model_tests(@directory.files, file_attributes, Fog.mocking?) do

    tests("#version") do
      tests("#version should not be null if versioning is enabled").returns(false) do
        @instance.version == nil
      end
    end

  end

  @directory.destroy

end
