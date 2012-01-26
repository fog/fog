Fog.mock!

Shindo.tests("Storage[:aws] | directory", [:aws]) do

  directory_attributes = {
    :key => 'fogdirectorytests'
  }

  model_tests(Fog::Storage[:aws].directories, directory_attributes, Fog.mocking?) do

    tests("#versioning=") do
      tests("#versioning=(true)").succeeds do
        @instance.versioning = true
      end

      tests("#versioning=(true) sets versioning to 'Enabled'").returns('Enabled') do
        @instance.versioning = true
        @instance.connection.get_bucket_versioning(@instance.key).body['VersioningConfiguration']['Status']
      end

      tests("#versioning=(false)").succeeds do
        @instance.versioning = false
      end

      tests("#versioning=(false) sets versioning to 'Suspended'").returns('Suspended') do
        @instance.versioning = false
        @instance.connection.get_bucket_versioning(@instance.key).body['VersioningConfiguration']['Status']
      end
    end

  end

  model_tests(Fog::Storage[:aws].directories, directory_attributes, Fog.mocking?) do

    tests("#versioning?") do
      tests("#versioning? false if not enabled").returns(false) do
        @instance.versioning?
      end

      tests("#versioning? true if enabled").returns(true) do
        @instance.connection.put_bucket_versioning(@instance.key, 'Enabled')
        @instance.versioning?
      end

      tests("#versioning? false if suspended").returns(false) do
        @instance.connection.put_bucket_versioning(@instance.key, 'Suspended')
        @instance.versioning?
      end
    end

  end

  model_tests(Fog::Storage[:aws].directories, directory_attributes, Fog.mocking?) do
    @instance.versioning = true

    versions = []
    versions << @instance.connection.put_object(@instance.key, 'one', 'abcde').headers['x-amz-version-id']
    versions << @instance.connection.put_object(@instance.key, 'one', '32423').headers['x-amz-version-id']
    versions << @instance.connection.delete_object(@instance.key, 'one').headers['x-amz-version-id']
    versions << @instance.connection.put_object(@instance.key, 'two', 'aoeu').headers['x-amz-version-id']

    tests('#versions') do
      tests('#versions.size includes versions (including DeleteMarkers) for all keys').returns(4) do
        @instance.versions.size
      end

      tests('#versions returns the correct versions').returns(versions) do
        @instance.versions.collect(&:version)
      end
    end

    @instance.versions.each(&:destroy)
  end

end