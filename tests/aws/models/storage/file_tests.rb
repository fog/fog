Shindo.tests("Storage[:aws] | file", [:aws]) do

  require 'tempfile'

  file_attributes = {
    :key => 'fog_file_tests',
    :body => lorem_file,
    :public => true
  }

  directory_attributes = {
    # Add a random suffix to prevent collision
    :key => "fogfilestests-#{rand(65536)}"
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

    tests("multipart upload") do
      pending if Fog.mocking?

      # A 6MB file
      @large_file = Tempfile.new("fog-test-aws-s3-multipart")
      6.times { @large_file.write("x" * (1024**2)) }
      @large_file.rewind

      tests("#save(:multipart_chunk_size => 5242880)").succeeds do
        @directory.files.create(:key => 'multipart-upload', :body => @large_file, :multipart_chunk_size => 5242880)
      end

      @large_file.close

    end

  end

  @directory.versions.each(&:destroy)
  @directory.destroy

end
