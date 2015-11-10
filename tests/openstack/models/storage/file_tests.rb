Shindo.tests('Fog::OpenStack::Storage | file', ['openstack']) do

  pending if Fog.mocking?

  def object_attributes(file=@instance)
    @instance.service.head_object(@directory.key, file.key).headers
  end

  def object_meta_attributes
    @instance.service.head_object(@directory.key, @instance.key).headers.reject {|k, v| !(k =~ /X-Object-Meta-/)}
  end

  def clear_metadata
    @instance.metadata.tap do |metadata|
      metadata.each_pair {|k, v| metadata[k] = nil }
    end
  end

  file_attributes = {
    :key => 'fog_file_tests',
    :body => lorem_file
  }

  directory_attributes = {
    # Add a random suffix to prevent collision
    :key => "fogfilestests-#{rand(65536)}"
  }

  @directory = Fog::Storage[:openstack].
    directories.
    create(directory_attributes)

  model_tests(@directory.files, file_attributes.merge(:etag => 'foo'), Fog.mocking?) do
    tests('#save should not blow up with etag') do
      @instance.save
    end
  end

  model_tests(@directory.files, file_attributes, Fog.mocking?) do

    tests("#metadata should load empty metadata").returns({}) do
      @instance.metadata
    end

    tests('#save') do

      tests('#metadata') do

        before do
          @instance.metadata[:foo] = 'bar'
          @instance.save
        end

        after do
          clear_metadata
          @instance.save
        end

        tests("should update metadata").returns('bar') do
          object_meta_attributes['X-Object-Meta-Foo']
        end

        tests('should cache metadata').returns('bar') do
          @instance.metadata[:foo]
        end

        tests('should remove empty metadata').returns({}) do
          @instance.metadata[:foo] = nil
          @instance.save
          object_meta_attributes
        end

      end

      tests('#content_disposition') do
        before do
          @instance = @directory.files.create :key => 'meta-test', :body => lorem_file, :content_disposition => 'ho-ho-ho'
        end

        after do
          clear_metadata
          @instance.save
        end

        tests("sets Content-Disposition on create").returns("ho-ho-ho") do
          object_attributes(@instance)["Content-Disposition"]
        end
      end

      tests('#metadata keys') do

        after do
          clear_metadata
          @instance.save
        end

        @instance.metadata[:foo_bar] = 'baz'
        tests("should support compound key names").returns('baz') do
          @instance.save
          object_meta_attributes['X-Object-Meta-Foo-Bar']
        end

        @instance.metadata['foo'] = 'bar'
        tests("should support string keys").returns('bar') do
          @instance.save
          object_meta_attributes['X-Object-Meta-Foo']
        end

        @instance.metadata['foo_bar'] = 'baz'
        tests("should support compound string key names").returns('baz') do
          @instance.save
          object_meta_attributes['X-Object-Meta-Foo-Bar']
        end

        @instance.metadata['foo-bar'] = 'baz'
        tests("should support hyphenated keys").returns('baz') do
          @instance.save
          object_meta_attributes['X-Object-Meta-Foo-Bar']
        end

        @instance.metadata['foo-bar']  = 'baz'
        @instance.metadata[:'foo_bar'] = 'bref'
        tests("should only support one value per metadata key").returns('bref') do
          @instance.save
          object_meta_attributes['X-Object-Meta-Foo-Bar']
        end

      end

    end

    tests("#access_control_allow_origin") do

      tests("#access_control_allow_origin should default to nil").returns(nil) do
        @instance.access_control_allow_origin
      end

      @instance.access_control_allow_origin = 'http://example.com'
      @instance.save
      tests("#access_control_allow_origin should return access control attribute").returns('http://example.com') do
        @instance.access_control_allow_origin
      end

      @instance.access_control_allow_origin = 'foo'
      @instance.save
      tests("#access_control_allow_origin= should update access_control_allow_origin").returns('bar') do
        @instance.access_control_allow_origin = 'bar'
        @instance.save
        @instance.access_control_allow_origin
      end

      tests("#access_control_allow_origin= should not blow up on nil") do
        @instance.access_control_allow_origin = nil
        @instance.save
      end

    end

    tests("#delete_at") do
      @delete_at_time = (Time.now + 300).to_i

      tests("#delete_at should default to nil").returns(nil) do
        @instance.delete_at
      end

      @instance.delete_at = @delete_at_time
      @instance.save
      tests("#delete_at should return delete_at attribute").returns(@delete_at_time) do
        @instance.delete_at
      end

      @instance.delete_at = @delete_at_time
      @instance.save
      tests("#delete_at= should update delete_at").returns(@delete_at_time + 100) do
        @instance.delete_at = @delete_at_time + 100
        @instance.save
        @instance.delete_at
      end

      tests("#delete_at= should not blow up on nil") do
        @instance.delete_at = nil
        @instance.save
      end
    end
  end

  model_tests(@directory.files, file_attributes, Fog.mocking?) do

    tests("#origin") do

      tests("#origin should default to nil").returns(nil) do
        @instance.save
        @instance.origin
      end

      @instance.origin = 'http://example.com'
      @instance.save
      tests("#origin should return access control attributes").returns('http://example.com') do
        @instance.origin
      end
      @instance.attributes.delete('Origin')

      @instance.origin = 'foo'
      @instance.save
      tests("#origin= should update origin").returns('bar') do
        @instance.origin = 'bar'
        @instance.save
        @instance.origin
      end

      tests("#origin= should not blow up on nil") do
        @instance.origin = nil
        @instance.save
      end

    end

    tests("#content_encoding") do

      tests("#content_encoding should default to nil").returns(nil) do
        @instance.save
        @instance.content_encoding
      end

      @instance.content_encoding = 'gzip'
      @instance.save
      tests("#content_encoding should return the content encoding").returns('gzip') do
        @instance.content_encoding
      end
      @instance.attributes.delete('content_encoding')

      @instance.content_encoding = 'foo'
      @instance.save
      tests("#content_encoding= should update content_encoding").returns('bar') do
        @instance.content_encoding = 'bar'
        @instance.save
        @instance.content_encoding
      end

      tests("#content_encoding= should not blow up on nil") do
        @instance.content_encoding = nil
        @instance.save
      end

    end

  end

  @directory.destroy

end
