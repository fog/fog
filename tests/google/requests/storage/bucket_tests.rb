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

    tests("#put_bucket('fogbuckettests')").succeeds do
      Fog::Storage[:google].put_bucket('fogbuckettests')
    end

    tests("#get_service").formats(@service_format) do
      Fog::Storage[:google].get_service.body
    end

    file = Fog::Storage[:google].directories.get('fogbuckettests').files.create(:body => 'y', :key => 'x')

    tests("#get_bucket('fogbuckettests)").formats(@bucket_format) do
      Fog::Storage[:google].get_bucket('fogbuckettests').body
    end

    file.destroy

    tests("#delete_bucket('fogbuckettests')").succeeds do
      Fog::Storage[:google].delete_bucket('fogbuckettests')
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
