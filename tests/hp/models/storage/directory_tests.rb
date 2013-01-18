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
