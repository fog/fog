Shindo.tests('Fog::Storage[:internetarchive] | bucket requests', ["internetarchive"]) do
  @ia_bucket_name = 'fogbuckettests-' + Time.now.to_i.to_s(32)

  tests('success') do

    @bucket_format = {
      'CommonPrefixes'  => [],
      'IsTruncated'     => Fog::Boolean,
      'Marker'          => NilClass,
      'MaxKeys'         => Integer,
      'Name'            => String,
      'Prefix'          => NilClass,
      'Contents'    => [{
        'ETag'          => String,
        'Key'           => String,
        'LastModified'  => Time,
        'Owner' => {
          'DisplayName' => String,
          'ID'          => String
        },
        'Size' => Integer
      }]
    }
    @bucket_lifecycle_format = {
      'Rules' => [{
         'ID'         => String,
         'Prefix'     => Fog::Nullable::String,
         'Enabled'    => Fog::Boolean,
         'Expiration' => Fog::Nullable::Hash,
         'Transition' => Fog::Nullable::Hash
       }]
    }

    @service_format = {
      'Buckets' => [{
        'CreationDate'  => Time,
        'Name'          => String,
      }],
      'Owner'   => {
        'DisplayName' => String,
        'ID'          => String
      }
    }

    tests("#put_bucket('#{@ia_bucket_name}')").succeeds do
      Fog::Storage[:internetarchive].put_bucket(@ia_bucket_name)
      @aws_owner = Fog::Storage[:internetarchive].get_bucket_acl(Fog::Storage[:internetarchive].directories.first.key).body['Owner']
    end

    tests("#get_service").formats(@service_format) do
      Fog::Storage[:internetarchive].get_service.body
    end

    dirs = Fog::Storage[:internetarchive].directories.get(@ia_bucket_name)
    file = Fog::Storage[:internetarchive].directories.get(@ia_bucket_name).files.create(:body => 'y', :key => 'x')

    tests("#get_bucket('#{@ia_bucket_name}')").formats(@bucket_format) do
      Fog::Storage[:internetarchive].get_bucket(@ia_bucket_name).body
    end

    file.destroy

    file1 = Fog::Storage[:internetarchive].directories.get(@ia_bucket_name).files.create(:body => 'a',    :key => 'a/a1/file1')
    file2 = Fog::Storage[:internetarchive].directories.get(@ia_bucket_name).files.create(:body => 'ab',   :key => 'a/file2')
    file3 = Fog::Storage[:internetarchive].directories.get(@ia_bucket_name).files.create(:body => 'abc',  :key => 'b/file3')
    file4 = Fog::Storage[:internetarchive].directories.get(@ia_bucket_name).files.create(:body => 'abcd', :key => 'file4')

    tests("#get_bucket('#{@ia_bucket_name}')") do
      before do
        @bucket = Fog::Storage[:internetarchive].get_bucket(@ia_bucket_name)
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(["a/a1/file1", "a/file2", "b/file3", "file4"]) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['Contents'].map{|n| n['Size']}").returns([1, 2, 3, 4]) do
        @bucket.body['Contents'].map{|n| n['Size']}
      end

      tests(".body['CommonPrefixes']").returns([]) do
        @bucket.body['CommonPrefixes']
      end
    end

    tests("#get_bucket('#{@ia_bucket_name}', 'delimiter' => '/')") do
      before do
        @bucket = Fog::Storage[:internetarchive].get_bucket(@ia_bucket_name, 'delimiter' => '/')
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(['file4']) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['CommonPrefixes']").returns(['a/', 'b/']) do
        @bucket.body['CommonPrefixes']
      end
    end

    tests("#get_bucket('#{@ia_bucket_name}', 'delimiter' => '/', 'prefix' => 'a/')") do
      before do
        @bucket = Fog::Storage[:internetarchive].get_bucket(@ia_bucket_name, 'delimiter' => '/', 'prefix' => 'a/')
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(['a/file2']) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['CommonPrefixes']").returns(['a/a1/']) do
        @bucket.body['CommonPrefixes']
      end
    end

    file1.destroy; file2.destroy; file3.destroy; file4.destroy

    tests("#get_bucket_location('#{@ia_bucket_name}')").formats('LocationConstraint' => NilClass) do
      Fog::Storage[:internetarchive].get_bucket_location(@ia_bucket_name).body
    end

    tests("#get_request_payment('#{@ia_bucket_name}')").formats('Payer' => String) do
      Fog::Storage[:internetarchive].get_request_payment(@ia_bucket_name).body
    end

    tests("#put_request_payment('#{@ia_bucket_name}', 'Requester')").succeeds do
      Fog::Storage[:internetarchive].put_request_payment(@ia_bucket_name, 'Requester')
    end

    tests("#put_bucket_website('#{@ia_bucket_name}', 'index.html')").succeeds do
      Fog::Storage[:internetarchive].put_bucket_website(@ia_bucket_name, 'index.html')
    end

    tests("#put_bucket_acl('#{@ia_bucket_name}', 'private')").succeeds do
      Fog::Storage[:internetarchive].put_bucket_acl(@ia_bucket_name, 'private')
    end

    acl = {
      'Owner' => @aws_owner,
      'AccessControlList' => [
        {
          'Grantee' => @aws_owner,
          'Permission' => "FULL_CONTROL"
        }
      ]
    }
    tests("#put_bucket_acl('#{@ia_bucket_name}', hash with id)").returns(acl) do
      Fog::Storage[:internetarchive].put_bucket_acl(@ia_bucket_name, acl)
      Fog::Storage[:internetarchive].get_bucket_acl(@ia_bucket_name).body
    end

    tests("#put_bucket_acl('#{@ia_bucket_name}', hash with email)").returns({
        'Owner' => @aws_owner,
        'AccessControlList' => [
          {
            'Grantee' => { 'ID' => 'f62f0218873cfa5d56ae9429ae75a592fec4fd22a5f24a20b1038a7db9a8f150', 'DisplayName' => 'mtd' },
            'Permission' => "FULL_CONTROL"
          }
        ]
    }) do
      pending if Fog.mocking?
      Fog::Storage[:internetarchive].put_bucket_acl(@ia_bucket_name, {
        'Owner' => @aws_owner,
        'AccessControlList' => [
          {
            'Grantee' => { 'EmailAddress' => 'mtd@amazon.com' },
            'Permission' => "FULL_CONTROL"
          }
        ]
      })
      Fog::Storage[:internetarchive].get_bucket_acl(@ia_bucket_name).body
    end

    acl = {
      'Owner' => @aws_owner,
      'AccessControlList' => [
        {
          'Grantee' => { 'URI' => 'http://acs.amazonaws.com/groups/global/AllUsers' },
          'Permission' => "FULL_CONTROL"
        }
      ]
    }
    tests("#put_bucket_acl('#{@ia_bucket_name}', hash with uri)").returns(acl) do
      Fog::Storage[:internetarchive].put_bucket_acl(@ia_bucket_name, acl)
      Fog::Storage[:internetarchive].get_bucket_acl(@ia_bucket_name).body
    end

    tests("#delete_bucket_website('#{@ia_bucket_name}')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:internetarchive].delete_bucket_website(@ia_bucket_name)
    end

    tests('bucket lifecycle') do
      pending if Fog.mocking?

      lifecycle = {'Rules' => [{'ID' => 'test rule', 'Prefix' => '/prefix', 'Enabled' => true, 'Days' => 42}]}
      tests('non-existant bucket') do
        tests('#put_bucket_lifecycle').returns([404, 'NoSuchBucket']) do
          begin
            Fog::Storage[:internetarchive].put_bucket_lifecycle('fognonbucket', lifecycle)
          rescue Excon::Errors::NotFound => e
            [e.response.status, e.response.body.match(%r{<Code>(.*)</Code>})[1]]
          end
        end
        tests('#get_bucket_lifecycle').returns([404, 'NoSuchBucket']) do
          begin
            Fog::Storage[:internetarchive].get_bucket_lifecycle('fognonbucket')
          rescue Excon::Errors::NotFound => e
            [e.response.status, e.response.body.match(%r{<Code>(.*)</Code>})[1]]
          end
        end
        tests('#delete_bucket_lifecycle').returns([404, 'NoSuchBucket']) do
          begin
            Fog::Storage[:internetarchive].delete_bucket_lifecycle('fognonbucket')
          rescue Excon::Errors::NotFound => e
            [e.response.status, e.response.body.match(%r{<Code>(.*)</Code>})[1]]
          end
        end
      end
      tests('no lifecycle') do
        tests('#get_bucket_lifecycle').returns([404, 'NoSuchLifecycleConfiguration']) do
          begin
            Fog::Storage[:internetarchive].get_bucket_lifecycle(@ia_bucket_name)
          rescue Excon::Errors::NotFound => e
            [e.response.status, e.response.body.match(%r{<Code>(.*)</Code>})[1]]
          end
        end
        tests('#delete_bucket_lifecycle').succeeds do
          Fog::Storage[:internetarchive].delete_bucket_lifecycle(@ia_bucket_name)
        end
      end
      tests('create').succeeds do
        Fog::Storage[:internetarchive].put_bucket_lifecycle(@ia_bucket_name, lifecycle)
      end
      tests('read').formats(@bucket_lifecycle_format) do
        Fog::Storage[:internetarchive].get_bucket_lifecycle(@ia_bucket_name).body
      end
      lifecycle = { 'Rules' => 5.upto(6).map { |i| {'ID' => "rule\##{i}", 'Prefix' => i.to_s, 'Enabled' => true, 'Days' => i} } }
      lifecycle_return = { 'Rules' => 5.upto(6).map { |i| {'ID' => "rule\##{i}", 'Prefix' => i.to_s, 'Enabled' => true, 'Expiration' => {'Days' => i}} } }
      tests('update').returns(lifecycle_return) do
        Fog::Storage[:internetarchive].put_bucket_lifecycle(@ia_bucket_name, lifecycle)
        Fog::Storage[:internetarchive].get_bucket_lifecycle(@ia_bucket_name).body
      end
      lifecycle = {'Rules' => [{'ID' => 'test rule', 'Prefix' => '/prefix', 'Enabled' => true, 'Expiration' => {'Date' => '2012-12-31T00:00:00.000Z'}}]}
      tests('date').returns(lifecycle) do
        Fog::Storage[:internetarchive].put_bucket_lifecycle(@ia_bucket_name, lifecycle)
        Fog::Storage[:internetarchive].get_bucket_lifecycle(@ia_bucket_name).body
      end
      tests('delete').succeeds do
          Fog::Storage[:internetarchive].delete_bucket_lifecycle(@ia_bucket_name)
      end
      tests('read').returns([404, 'NoSuchLifecycleConfiguration']) do
        begin
          Fog::Storage[:internetarchive].get_bucket_lifecycle(@ia_bucket_name)
        rescue Excon::Errors::NotFound => e
          [e.response.status, e.response.body.match(%r{<Code>(.*)</Code>})[1]]
        end
      end
    end

    tests("put_bucket_cors('#{@ia_bucket_name}', cors)").succeeds do
      cors =  {'CORSConfiguration' =>
                  [
                    {
                      'AllowedOrigin' => 'http://localhost:3000',
                      'AllowedMethod' => ['POST', 'GET'],
                      'AllowedHeader' => '*',
                      'MaxAgeSeconds' => 3000
                    }
                  ]
              }
      Fog::Storage[:internetarchive].put_bucket_cors(@ia_bucket_name, cors)
    end

    tests("#delete_bucket('#{@ia_bucket_name}')").succeeds do
      Fog::Storage[:internetarchive].delete_bucket(@ia_bucket_name)
    end

  end

  # tests('failure') do

  #   tests("#delete_bucket('fognonbucket')").raises(Excon::Errors::NotFound) do
  #     Fog::Storage[:internetarchive].delete_bucket('fognonbucket')
  #   end

  #   @fognonempty = "fognonempty-#{rand(65536)}"
  #   @bucket = Fog::Storage[:internetarchive].directories.create(:key => "fognonempty-#{rand(65536)}")
  #   @file = @bucket.files.create(:key => 'foo', :body => 'bar')

  #   tests("#delete_bucket('fognonempty')").raises(Excon::Errors::Conflict) do
  #     Fog::Storage[:internetarchive].delete_bucket('fognonempty')
  #   end

  #   @file.destroy
  #   @bucket.destroy

  #   tests("#get_bucket('fognonbucket')").raises(Excon::Errors::NotFound) do
  #     Fog::Storage[:internetarchive].get_bucket('fognonbucket')
  #   end

  #   tests("#get_bucket_location('fognonbucket')").raises(Excon::Errors::NotFound) do
  #     Fog::Storage[:internetarchive].get_bucket_location('fognonbucket')
  #   end

  #   tests("#get_request_payment('fognonbucket')").raises(Excon::Errors::NotFound) do
  #     Fog::Storage[:internetarchive].get_request_payment('fognonbucket')
  #   end

  #   tests("#put_request_payment('fognonbucket', 'Requester')").raises(Excon::Errors::NotFound) do
  #     Fog::Storage[:internetarchive].put_request_payment('fognonbucket', 'Requester')
  #   end

  #   tests("#put_bucket_acl('fognonbucket', 'invalid')").raises(Excon::Errors::BadRequest) do
  #     Fog::Storage[:internetarchive].put_bucket_acl('fognonbucket', 'invalid')
  #   end

  #   tests("#put_bucket_website('fognonbucket', 'index.html')").raises(Excon::Errors::NotFound) do
  #     Fog::Storage[:internetarchive].put_bucket_website('fognonbucket', 'index.html')
  #   end

  # end

  # don't keep the bucket around
  # Fog::Storage[:internetarchive].delete_bucket(@ia_bucket_name) rescue nil
end
