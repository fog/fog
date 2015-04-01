Shindo.tests('Fog::Storage[:google] | bucket requests', ["google"]) do

  tests('success') do

    @bucket_format = {
      'CommonPrefixes' => [],
      'IsTruncated'     => Fog::Boolean,
      'Marker'          => NilClass,
      'Name'            => String,
      'Prefix'          => NilClass,
      'Contents'        => [{
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

    @service_format = {
      'Buckets' => [{
        'CreationDate'  => Time,
        'Name'          => String,
      }],
      'Owner'   => {
        'ID'          => String
      }
    }

    fog_bucket_name = 'fogbuckettests'

    tests("#put_bucket('#{fog_bucket_name}')").succeeds do
      Fog::Storage[:google].put_bucket(fog_bucket_name)
    end

    tests("#get_service").formats(@service_format) do
      Fog::Storage[:google].get_service.body
    end

    file = Fog::Storage[:google].directories.get(fog_bucket_name).files.create(:body => 'y', :key => 'x')

    tests("#get_bucket(#{fog_bucket_name})").formats(@bucket_format) do
      Fog::Storage[:google].get_bucket(fog_bucket_name).body
    end

    file.destroy

    tests("#delete_bucket(#{fog_bucket_name})").succeeds do
      Fog::Storage[:google].delete_bucket(fog_bucket_name)
    end

  end

  tests('failure') do

    tests("#delete_bucket('fognonbucket')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].delete_bucket('fognonbucket')
    end

    @bucket = Fog::Storage[:google].directories.create(:key => 'fognonempty')
    @file = @bucket.files.create(:key => 'foo', :body => 'bar')

    tests("#delete_bucket('fognonempty')").raises(Excon::Errors::Conflict) do
      Fog::Storage[:google].delete_bucket('fognonempty')
    end

    @file.destroy
    @bucket.destroy

    tests("#get_bucket('fognonbucket')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:google].get_bucket('fognonbucket')
    end

  end

end
