Shindo.tests('Fog::Storage[:aws] | bucket requests', [:aws]) do
  @aws_bucket_name = 'fogbuckettests-' + Time.now.to_i.to_s(32)

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

    tests("#put_bucket('#{@aws_bucket_name}')").succeeds do
      Fog::Storage[:aws].put_bucket(@aws_bucket_name)
    end

    tests("#get_service").formats(@service_format) do
      Fog::Storage[:aws].get_service.body
    end

    file = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'y', :key => 'x')

    tests("#get_bucket('#{@aws_bucket_name}')").formats(@bucket_format) do
      Fog::Storage[:aws].get_bucket(@aws_bucket_name).body
    end

    file.destroy

    file1 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'a',    :key => 'a/a1/file1')
    file2 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'ab',   :key => 'a/file2')
    file3 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'abc',  :key => 'b/file3')
    file4 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'abcd', :key => 'file4')

    tests("#get_bucket('#{@aws_bucket_name}')") do
      before do
        @bucket = Fog::Storage[:aws].get_bucket(@aws_bucket_name)
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

    tests("#get_bucket('#{@aws_bucket_name}', 'delimiter' => '/')") do
      before do
        @bucket = Fog::Storage[:aws].get_bucket(@aws_bucket_name, 'delimiter' => '/')
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(['file4']) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['CommonPrefixes']").returns(['a/', 'b/']) do
        @bucket.body['CommonPrefixes']
      end
    end

    tests("#get_bucket('#{@aws_bucket_name}', 'delimiter' => '/', 'prefix' => 'a/')") do
      before do
        @bucket = Fog::Storage[:aws].get_bucket(@aws_bucket_name, 'delimiter' => '/', 'prefix' => 'a/')
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(['a/file2']) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['CommonPrefixes']").returns(['a/a1/']) do
        @bucket.body['CommonPrefixes']
      end
    end

    file1.destroy; file2.destroy; file3.destroy; file4.destroy

    tests("#get_bucket_location('#{@aws_bucket_name}')").formats('LocationConstraint' => NilClass) do
      Fog::Storage[:aws].get_bucket_location(@aws_bucket_name).body
    end

    tests("#get_request_payment('#{@aws_bucket_name}')").formats('Payer' => String) do
      Fog::Storage[:aws].get_request_payment(@aws_bucket_name).body
    end

    tests("#put_request_payment('#{@aws_bucket_name}', 'Requester')").succeeds do
      Fog::Storage[:aws].put_request_payment(@aws_bucket_name, 'Requester')
    end

    tests("#put_bucket_website('#{@aws_bucket_name}', 'index.html')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:aws].put_bucket_website(@aws_bucket_name, 'index.html')
    end

    tests("#put_bucket_acl('#{@aws_bucket_name}', 'private')").succeeds do
      Fog::Storage[:aws].put_bucket_acl(@aws_bucket_name, 'private')
    end

    tests("#put_bucket_acl('#{@aws_bucket_name}', hash with id)").returns(<<-BODY) do
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
      Fog::Storage[:aws].put_bucket_acl(@aws_bucket_name, {
        'Owner' => { 'ID' => "8a6925ce4adf5f21c32aa379004fef", 'DisplayName' => "mtd@amazon.com" },
        'AccessControlList' => [
          {
            'Grantee' => { 'ID' => "8a6925ce4adf588a4532142d3f74dd8c71fa124b1ddee97f21c32aa379004fef", 'DisplayName' => "mtd@amazon.com" },
            'Permission' => "FULL_CONTROL"
          }
        ]
      })
      Fog::Storage[:aws].get_bucket_acl(@aws_bucket_name).body
    end

    tests("#put_bucket_acl('#{@aws_bucket_name}', hash with email)").returns(<<-BODY) do
<AccessControlPolicy>
  <Owner>
    <ID>8a6925ce4adf5f21c32aa379004fef</ID>
    <DisplayName>mtd@amazon.com</DisplayName>
  </Owner>
  <AccessControlList>
    <Grant>
      <Grantee xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="AmazonCustomerByEmail\">
        <EmailAddress>mtd@amazon.com</EmailAddress>
      </Grantee>
      <Permission>FULL_CONTROL</Permission>
    </Grant>
  </AccessControlList>
</AccessControlPolicy>
BODY
      Fog::Storage[:aws].put_bucket_acl(@aws_bucket_name, {
        'Owner' => { 'ID' => "8a6925ce4adf5f21c32aa379004fef", 'DisplayName' => "mtd@amazon.com" },
        'AccessControlList' => [
          {
            'Grantee' => { 'EmailAddress' => 'mtd@amazon.com' },
            'Permission' => "FULL_CONTROL"
          }
        ]
      })
      Fog::Storage[:aws].get_bucket_acl(@aws_bucket_name).body
    end

    tests("#put_bucket_acl('#{@aws_bucket_name}', hash with uri)").returns(<<-BODY) do
<AccessControlPolicy>
  <Owner>
    <ID>8a6925ce4adf5f21c32aa379004fef</ID>
    <DisplayName>mtd@amazon.com</DisplayName>
  </Owner>
  <AccessControlList>
    <Grant>
      <Grantee xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="Group">
        <URI>http://www.w3.org/2001/XMLSchema-instance</URI>
      </Grantee>
      <Permission>FULL_CONTROL</Permission>
    </Grant>
  </AccessControlList>
</AccessControlPolicy>
BODY
      Fog::Storage[:aws].put_bucket_acl(@aws_bucket_name, {
        'Owner' => { 'ID' => "8a6925ce4adf5f21c32aa379004fef", 'DisplayName' => "mtd@amazon.com" },
        'AccessControlList' => [
          {
            'Grantee' => { 'URI' => 'http://www.w3.org/2001/XMLSchema-instance' },
            'Permission' => "FULL_CONTROL"
          }
        ]
      })
      Fog::Storage[:aws].get_bucket_acl(@aws_bucket_name).body
    end

    tests("#delete_bucket_website('#{@aws_bucket_name}')").succeeds do
      pending if Fog.mocking?
      Fog::Storage[:aws].delete_bucket_website(@aws_bucket_name)
    end

    tests("#delete_bucket('#{@aws_bucket_name}')").succeeds do
      Fog::Storage[:aws].delete_bucket(@aws_bucket_name)
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
