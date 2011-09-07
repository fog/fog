Shindo.tests('Fog::Storage[:aws] | bucket requests', [:aws]) do

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
        'Size' => Integer,
        'StorageClass' => String
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

    tests("#put_bucket('fogbuckettests')").succeeds do
      Fog::Storage[:aws].put_bucket('fogbuckettests')
    end

    tests("#get_service").formats(@service_format) do
      Fog::Storage[:aws].get_service.body
    end

    file = Fog::Storage[:aws].directories.get('fogbuckettests').files.create(:body => 'y', :key => 'x')

    tests("#get_bucket('fogbuckettests)").formats(@bucket_format) do
      Fog::Storage[:aws].get_bucket('fogbuckettests').body
    end

    file.destroy

    file1 = Fog::Storage[:aws].directories.get('fogbuckettests').files.create(:body => 'a',    :key => 'a/a1/file1')
    file2 = Fog::Storage[:aws].directories.get('fogbuckettests').files.create(:body => 'ab',   :key => 'a/file2')
    file3 = Fog::Storage[:aws].directories.get('fogbuckettests').files.create(:body => 'abc',  :key => 'b/file3')
    file4 = Fog::Storage[:aws].directories.get('fogbuckettests').files.create(:body => 'abcd', :key => 'file4')

    tests("#get_bucket('fogbuckettests')") do
      before do
        @bucket = Fog::Storage[:aws].get_bucket('fogbuckettests')
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

    tests("#get_bucket('fogbuckettests', 'delimiter' => '/')") do
      before do
        @bucket = Fog::Storage[:aws].get_bucket('fogbuckettests', 'delimiter' => '/')
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(['file4']) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['CommonPrefixes']").returns(['a/', 'b/']) do
        @bucket.body['CommonPrefixes']
      end
    end

    tests("#get_bucket('fogbuckettests', 'delimiter' => '/', 'prefix' => 'a/')") do
      before do
        @bucket = Fog::Storage[:aws].get_bucket('fogbuckettests', 'delimiter' => '/', 'prefix' => 'a/')
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(['a/file2']) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['CommonPrefixes']").returns(['a/a1/']) do
        @bucket.body['CommonPrefixes']
      end
    end

    file1.destroy; file2.destroy; file3.destroy; file4.destroy

    tests("#get_bucket_location('fogbuckettests)").formats('LocationConstraint' => NilClass) do
      Fog::Storage[:aws].get_bucket_location('fogbuckettests').body
    end

    tests("#get_request_payment('fogbuckettests')").formats('Payer' => String) do
      Fog::Storage[:aws].get_request_payment('fogbuckettests').body
    end

    tests("#put_request_payment('fogbuckettests', 'Requester')").succeeds do
      Fog::Storage[:aws].put_request_payment('fogbuckettests', 'Requester')
    end

    tests("#put_bucket_website('fogbuckettests', 'index.html')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:aws].put_bucket_website('fogbuckettests', 'index.html')
    end

    tests("#delete_bucket_website('fogbuckettests')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:aws].delete_bucket_website('fogbuckettests')
    end

    tests("#delete_bucket('fogbuckettests')").succeeds do
      Fog::Storage[:aws].delete_bucket('fogbuckettests')
    end

    tests("#put_bucket_acl('fogbuckettests', 'private')").succeeds do
      Fog::Storage[:aws].put_bucket_acl('fogbuckettests', 'private')
    end

    tests("#put_bucket_acl('fogbuckettests', hash)").returns(true) do
      Fog::Storage[:aws].put_bucket_acl('fogbuckettests', {
        'Owner' => { 'ID' => "8a6925ce4adf5f21c32aa379004fef", 'DisplayName' => "mtd@amazon.com" },
        'AccessControlList' => [
          { 
            'Grantee' => { 'ID' => "8a6925ce4adf588a4532142d3f74dd8c71fa124b1ddee97f21c32aa379004fef", 'DisplayName' => "mtd@amazon.com" }, 
            'Permission' => "FULL_CONTROL" 
          }
        ]
      })
      Fog::Storage[:aws].get_bucket_acl('fogbuckettests').body == <<-BODY
<AccessControlPolicy>
  <Owner>
    <ID>8a6925ce4adf5f21c32aa379004fef</ID>
    <DisplayName>mtd@amazon.com</DisplayName>
  </Owner>
  <AccessControlList>
    <Grant>
      <Grantee xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="CanonicalUser">
        <ID>8a6925ce4adf588a4532142d3f74dd8c71fa124b1ddee97f21c32aa379004fef</ID>
        <DisplayName>mtd@amazon.com</DisplayName>
      </Grantee>
      <Permission>FULL_CONTROL</Permission>
    </Grant>
  </AccessControlList>
</AccessControlPolicy>
BODY
    end

  end

  tests('failure') do

    tests("#delete_bucket('fognonbucket')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].delete_bucket('fognonbucket')
    end

    @bucket = Fog::Storage[:aws].directories.create(:key => 'fognonempty')
    @file = @bucket.files.create(:key => 'foo', :body => 'bar')

    tests("#delete_bucket('fognonempty')").raises(Excon::Errors::Conflict) do
      Fog::Storage[:aws].delete_bucket('fognonempty')
    end

    @file.destroy
    @bucket.destroy

    tests("#get_bucket('fognonbucket')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].get_bucket('fognonbucket')
    end

    tests("#get_bucket_location('fognonbucket')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].get_bucket_location('fognonbucket')
    end

    tests("#get_request_payment('fognonbucket')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].get_request_payment('fognonbucket')
    end

    tests("#put_request_payment('fognonbucket', 'Requester')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].put_request_payment('fognonbucket', 'Requester')
    end

    tests("#put_bucket_acl('fognonbucket', 'invalid')").raises(Excon::Errors::BadRequest) do
      Fog::Storage[:aws].put_bucket_acl('fognonbucket', 'invalid')
    end

  end

end
