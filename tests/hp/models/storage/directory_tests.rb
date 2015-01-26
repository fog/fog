Shindo.tests("Fog::Storage[:hp] | directory", ['hp', 'storage']) do

  model_tests(Fog::Storage[:hp].directories, {:key => "fogdirtests"}, true) do

    tests('success') do

      tests("#grant('pr')").succeeds do
        @instance.grant('pr')
        tests("public?").returns(true) do
          @instance.public?
        end
      end

      tests("#revoke('pr')").succeeds do
        @instance.revoke('pr')
        tests("public?").returns(false) do
          @instance.public?
        end
      end

      @instance.files.create(:key => 'sample.txt', :body => lorem_file)
      tests("#files").succeeds do
        @instance.files
      end
      @instance.files.get('sample.txt').destroy

      tests("#cdn_enable=(true)").succeeds do
        pending if Fog.mocking?
        @instance.cdn_enable=(true)
        tests("cdn_enabled?").returns(true) do
          pending if Fog.mocking?
          @instance.cdn_enable?
        end
      end

      tests("#cdn_public_url").succeeds do
        pending if Fog.mocking?
        @instance.cdn_public_url
      end

      tests("#cdn_public_ssl_url").succeeds do
        pending if Fog.mocking?
        @instance.cdn_public_ssl_url
      end

      # metadata tests
      tests('#metadata.all').succeeds do
        @instance.metadata.all
      end

      tests('#metadata.set').succeeds do
        @instance.metadata.set('X-Container-Meta-One' => 'One')
      end

      tests('#metadata.get set meta').succeeds do
        meta = @instance.metadata.get('X-Container-Meta-One')
        tests('gets correct value') do
          meta.value == 'One'
        end
        meta
      end

      tests('#metadata.update').succeeds do
        @instance.metadata.update('X-Container-Meta-One' => 'One Updated')
      end

      tests('#metadata.get updated meta').succeeds do
        meta = @instance.metadata.get('X-Container-Meta-One')
        tests('gets correct value') do
          meta.value == 'One Updated'
        end
        meta
      end

      # metadata set via setter
      tests('#metadata=').succeeds do
        @instance.metadata = {'X-Container-Meta-Two' => 'Two'}
        @instance.save
      end

      tests('#metadata.get set meta via setter').succeeds do
        meta = @instance.metadata.get('X-Container-Meta-Two')
        tests('gets correct value') do
          meta.value == 'Two'
        end
        meta
      end

      #metadata set via Meta object
      tests('metadata set via Meta object').succeeds do
        m = Fog::Storage::HP::Meta.new
        m.key = 'X-Container-Meta-Three'
        m.value = 'Three'
        @instance.metadata << m
        @instance.save
      end

      tests('#metadata.get set via Meta object').succeeds do
        meta = @instance.metadata.get('X-Container-Meta-Three')
        tests('gets correct value') do
          meta.value == 'Three'
        end
        meta
      end

      # invalid metadata
      tests("#metadata.get('invalid-meta')").succeeds do
        meta = @instance.metadata.get('X-Container-Meta-InValidMeta')
        tests('gets nil') do
          meta == nil
        end
        meta
      end

    end

    tests('failure') do

      tests("#grant('invalid-acl')").raises(ArgumentError) do
        @instance.grant('invalid-acl')
      end

      tests("#revoke('invalid-acl')").raises(ArgumentError) do
        @instance.revoke('invalid-acl')
      end

    end

  end

end
