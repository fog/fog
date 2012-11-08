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

    tests("#access_control_allow_origin") do

      tests("#access_control_allow_origin should default to nil").returns(nil) do
        @instance.access_control_allow_origin
      end

      @instance.access_control_allow_origin = 'http://example.com'
      tests("#access_control_allow_origin should return access control attribute").returns('http://example.com') do
        @instance.access_control_allow_origin
      end

      @instance.access_control_allow_origin = 'foo'
      tests("#access_control_allow_origin= should update access_control_allow_origin").returns('bar') do
        @instance.access_control_allow_origin = 'bar'
        @instance.access_control_allow_origin
      end

      tests("#access_control_allow_origin= should not blow up on nil") do
        @instance.access_control_allow_origin = nil
      end

    end

  end


  model_tests(@directory.files, file_attributes, Fog.mocking?) do

    tests("#origin") do

      tests("#origin should default to nil").returns(nil) do
        @instance.origin
      end

      @instance.origin = 'http://example.com'
      tests("#origin should return access control attributes").returns('http://example.com') do
        @instance.origin
      end
      @instance.attributes.delete('Origin')

      @instance.attributes['Origin'] = 'foo'
      tests("#origin= should update origin").returns('bar') do
        @instance.origin = 'bar'
        @instance.origin
      end

      tests("#origin= should not blow up on nil") do
        @instance.origin = nil
      end

    end

  end
  @directory.destroy
end
