Shindo.tests('Fog::Rackspace::Storage | file', ['rackspace']) do

  file_attributes = {
    :key => 'fog_file_tests',
    :body => lorem_file
  }

  directory_attributes = {
    # Add a random suffix to prevent collision
    :key => "fogfilestests-#{rand(65536)}"
  }

  @directory = Fog::Storage[:rackspace].
    directories.
    create(directory_attributes)

  model_tests(@directory.files, file_attributes, Fog.mocking?) do

    tests("#metadata") do

      tests("#metadata should default to empty").returns({}) do
        @instance.metadata
      end

      @instance.attributes['X-Object-Meta-Fog-Foo'] = 'foo'
      tests("#metadata should return only metadata attributes").returns({'X-Object-Meta-Fog-Foo' => 'foo'}) do
        @instance.metadata
      end
      @instance.attributes.delete('X-Object-Meta-Fog-Foo')

      @instance.attributes['X-Object-Meta-Fog-Foo'] = 'foo'
      tests("#metadata= should update metadata").returns('bar') do
        @instance.metadata = {'X-Object-Meta-Fog-Foo' => 'bar'}
        @instance.attributes['X-Object-Meta-Fog-Foo']
      end
      
      tests("#metadata= should not blow up on nil") do
        @instance.metadata = nil
      end

    end

  end

  model_tests(@directory.files, file_attributes.merge('X-Object-Meta-Fog-Foo' => 'foo'), Fog.mocking?) do

    tests("#save") do

      tests("#save should merge metadata").returns('foo') do
        @instance.metadata['X-Object-Meta-Fog-Foo']
      end

      @instance.attributes['X-Object-Meta-Fog-Foo'] = nil
      tests("#save should remove empty metadata").returns(false) do
        @instance.save
        @instance.attributes.has_key?('X-Object-Meta-Fog-Foo')
      end

    end

  end

  @directory.destroy
end