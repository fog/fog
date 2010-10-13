Shindo.tests('AWS::Storage | bucket requests', ['aws']) do

  tests('success') do

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
      AWS[:storage].put_bucket('fogbuckettests')
    end

    tests("#get_service").formats(@service_format) do
      AWS[:storage].get_service.body
    end

    tests("#delete_bucket('fogbuckettests')").succeeds do
      AWS[:storage].delete_bucket('fogbuckettests')
    end

  end

  tests('failure') do

    tests("#delete_bucket('fognonbucket')").raises(Excon::Errors::NotFound) do
      AWS[:storage].delete_bucket('fognonbucket')
    end

    @bucket = AWS[:storage].directories.create(:key => 'fognonempty')
    @file = @bucket.files.create(:key => 'foo', :body => 'bar')

    tests("#delete_bucket('fognonempty')").raises(Excon::Errors::Conflict) do
      AWS[:storage].delete_bucket('fognonempty')
    end

    @file.destroy
    @bucket.destroy

  end

end
