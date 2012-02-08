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


    @directory.files.create(:key => @instance.key)
    @instance.destroy

    tests("#versions") do
      tests('#versions.size includes versions (including DeleteMarkers) for all keys').returns(3) do
        @instance.versions.size
      end

      tests('#versions are all for the correct key').returns(true) do
        @instance.versions.all? { |v| v.key == @instance.key }
      end
    end

    tests("#destroy") do
      tests("#destroy a specific version should delete the version, not create a DeleteMarker").returns(2) do
        @instance.destroy('versionId' => @instance.version)
        @instance.versions.all.size
      end
    end

  end

  @directory.versions.each(&:destroy)
  @directory.destroy

end
