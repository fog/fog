Shindo.tests("Storage[:aws] | versions", ["aws"]) do

  file_attributes = {
      :key => 'fog_file_tests',
      :body => lorem_file,
      :public => true
  }

  directory_attributes = {
      :key => 'fogfilestests'
  }

  model_tests(Fog::Storage[:aws].directories, directory_attributes, Fog.mocking?) do
    @instance.versioning = true

    versions = []
    versions << @instance.connection.put_object(@instance.key, 'one', 'abcde').headers['x-amz-version-id']

    puts versions.first

    versions << @instance.connection.put_object(@instance.key, 'one', '32423').headers['x-amz-version-id']
    versions << @instance.connection.delete_object(@instance.key, 'one').headers['x-amz-version-id']
    versions.reverse!

    puts versions.first

    versions << @instance.connection.put_object(@instance.key, 'two', 'aoeu').headers['x-amz-version-id']

    tests('#versions') do
      tests('#versions.size includes versions (including DeleteMarkers) for all keys').returns(4) do
        @instance.versions.all.size
      end

      tests('#versions returns the correct versions').returns(versions) do
        @instance.versions.all.collect(&:version)
      end
    end

    tests("#all") do
      tests("#all for a directory returns all versions, regardless of key").returns(versions) do
        @instance.versions.all.collect(&:version)
      end

      tests("#all for file returns only versions for that file").returns(1) do
        @instance.files.get('two').versions.all.collect(&:version).size
      end

      tests("#all for file returns only versions for that file").returns(versions.last) do
        @instance.files.get('two').versions.all.collect(&:version).first
      end
    end

    @instance.versions.each(&:destroy)
  end

end
