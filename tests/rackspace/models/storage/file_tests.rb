require 'fog/rackspace/models/storage/file'

Shindo.tests('Fog::Rackspace::Storage | file', ['rackspace']) do

  tests("last_modified=") do
    tests("no timezone") do
      file = Fog::Storage::Rackspace::File.new
      file.last_modified = "2013-05-09T22:20:59.287990"
      returns(Fog::Time.utc(2013, 5, 9, 22, 20, 59, 287990, nil) == file.last_modified) { true }
    end
    tests("with timezone") do
      file = Fog::Storage::Rackspace::File.new
      file.last_modified = "Thu, 09 May 2015 22:20:59 GMT"
      returns(Fog::Time.utc(2015, 5, 9, 22, 20, 59, 0, nil).to_i == file.last_modified.to_i) { true }
    end
    tests("with time") do
      file = Fog::Storage::Rackspace::File.new
      file.last_modified = Fog::Time.utc(2015, 5, 9, 22, 20, 59, 0, nil)
      returns(Fog::Time.utc(2015, 5, 9, 22, 20, 59, 0, nil) == file.last_modified) { true }
    end
    tests("nil") do
      file = Fog::Storage::Rackspace::File.new
      file.last_modified = nil
      returns(nil) { file.last_modified }
    end
    tests("empty string") do
      file = Fog::Storage::Rackspace::File.new
      file.last_modified = ""
      returns("") { file.last_modified }
    end
  end

  def object_attributes(file=@instance)
    @instance.service.head_object(@directory.key, file.key).headers
  end

  def object_meta_attributes(file=@instance)
    object_attributes(file).reject {|k, v| !(k =~ /X-Object-Meta-/)}
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

  @service = Fog::Storage.new :provider => 'rackspace', :rackspace_temp_url_key => "my_secret"
  @directory = @service.directories.create(directory_attributes)

  model_tests(@directory.files, file_attributes, Fog.mocking?) do

    tests("#metadata should load empty metadata").returns({}) do
      @instance.metadata.data
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

        tests("removes one key while leaving the other") do
          @instance.metadata[:color] = "green"
          @instance.save
          returns({"X-Object-Meta-Foo"=>"bar", "X-Object-Meta-Color"=>"green"}) { object_meta_attributes  }

          tests("set metadata[:color] = nil").returns({"X-Object-Meta-Foo"=>"bar"}) do
            @instance.metadata[:color] = nil
            @instance.save

            object_meta_attributes
          end
        end
      end

      begin
        tests("sets metadata on create").returns("true") do
          @file = @directory.files.create :key => 'meta-test', :body => lorem_file, :metadata => {:works => true }
          object_meta_attributes(@file)["X-Object-Meta-Works"]
        end

        tests("sets Content-Disposition on create").returns("ho-ho-ho") do
          @file = @directory.files.create :key => 'meta-test', :body => lorem_file, :content_disposition => 'ho-ho-ho'
          object_attributes(@file)["Content-Disposition"]
        end
      ensure
        @file.destroy if @file
      end

      tests('urls') do
        tests('no CDN') do

          tests('url') do
            tests('http').succeeds do
              expire_time = Time.now + 3600
              url = @instance.url(expire_time)
              url =~ /^http:/
            end
            tests('https').succeeds do
              @directory.service.instance_variable_set "@rackspace_cdn_ssl", true
              expire_time = Time.now + 3600
              url = @instance.url(expire_time)
              url =~ /^https:/
            end
            @directory.service.instance_variable_set "@rackspace_cdn_ssl", false
          end

          tests('#public_url') do

             tests('http').returns(nil) do
               @instance.public_url
              end

              @directory.cdn_cname = "my_cname.com"
              tests('cdn_cname').returns(nil) do
                @instance.public_url
              end

              @directory.cdn_cname = nil
              @directory.service.instance_variable_set "@rackspace_cdn_ssl", true
              tests('ssl').returns(nil) do
                @instance.public_url
              end
              @directory.service.instance_variable_set "@rackspace_cdn_ssl", nil
           end

           tests('#ios_url').returns(nil) do
             @instance.ios_url
           end

           tests('#streaming_url').returns(nil) do
             @instance.streaming_url
           end
        end
        tests('With CDN') do
          tests('#public_url') do
            @directory.public = true
            @directory.save

            tests('http').returns(0) do
              @instance.public_url  =~ /http:\/\/.*#{@instance.key}/
             end

             @directory.cdn_cname = "my_cname.com"
             tests('cdn_cname').returns(0) do
               @instance.public_url  =~ /my_cname\.com.*#{@instance.key}/
             end

             @directory.cdn_cname = nil
             @directory.service.instance_variable_set "@rackspace_cdn_ssl", true
             tests('ssl').returns(0) do
               @instance.public_url =~ /https:\/\/.+\.ssl\..*#{@instance.key}/
             end
             @directory.service.instance_variable_set "@rackspace_cdn_ssl", nil
          end

          tests('#ios_url').returns(0) do
            @instance.ios_url =~ /http:\/\/.+\.iosr\..*#{@instance.key}/
          end

          tests('#streaming_url').returns(0) do
            @instance.streaming_url =~ /http:\/\/.+\.stream\..*#{@instance.key}/
          end
        end

      tests('etags') do
        text = lorem_file.read
        md5 = Digest::MD5.new
        md5 << text
        etag = md5.hexdigest

        begin
          tests('valid tag').returns(true) do
            @file = @directory.files.create :key => 'valid-etag.txt', :body => text,  :etag => etag
            @file.reload
            @file.etag == etag
          end
        ensure
          @file.destroy if @file
        end

        tests('invalid tag').raises(Fog::Storage::Rackspace::ServiceError) do
          @directory.files.create :key => 'invalid-etag.txt', :body => text,  :etag => "bad-bad-tag"
        end
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

    tests("#delete_after") do
      @delete_after_time = (Time.now + 300).to_i

      tests("#delete_after should default to nil").returns(nil) do
        @instance.delete_after
      end

      @instance.delete_after = @delete_after_time
      @instance.save
      tests("#delete_after should return delete_after attribute").returns(@delete_after_time) do
        @instance.delete_after
      end

      @instance.delete_after = @delete_after_time
      @instance.save
      tests("#delete_after= should update delete_after").returns(@delete_after_time + 100) do
        @instance.delete_after = @delete_after_time + 100
        @instance.save
        @instance.delete_after
      end

      tests("#delete_after= should not blow up on nil") do
        @instance.delete_after = nil
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
