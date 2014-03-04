Shindo.tests("Storage[:internetarchive] | file", ["internetarchive"]) do

  # Fog.mock!

  require 'tempfile'

  file_attributes = {
    :key => 'fog_file_tests',
    :body => lorem_file,
    :public => true,
    :auto_make_bucket => 1,
  }

  directory_attributes = {
    # Add a random suffix to prevent collision
    :key => "fogfilestests-#{rand(65536)}",
    :collections => ['test_collection']
  }

  @directory = Fog::Storage[:internetarchive].directories.create(directory_attributes)

  model_tests(@directory.files, file_attributes, Fog.mocking?) do

    tests("#set_metadata_array_headers") do

      @instance.collections = ['test_collection', 'opensource']
      @options = {}
      @instance.set_metadata_array_headers(:collections, @options)

      tests("#set_metadata_array_headers should set options").returns(true) do
        @options['x-archive-meta01-collection'] == 'opensource' &&
        @options['x-archive-meta02-collection'] == 'test_collection'
      end
    end

  end

  model_tests(@directory.files, file_attributes, Fog.mocking?) do

    tests("multipart upload") do
      pending if Fog.mocking?

      # A 6MB file
      @large_file = Tempfile.new("fog-test-ia-s3-multipart")
      6.times { @large_file.write("x" * (1024**2)) }
      @large_file.rewind

      tests("#save(:multipart_chunk_size => 5242880)").succeeds do
        @directory.files.create(:key => 'multipart-upload', :body => @large_file, :multipart_chunk_size => 5242880)
      end

      @large_file.close

    end

  end

  # @directory.versions.each(&:destroy)
  @directory.destroy

end
