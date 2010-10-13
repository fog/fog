Shindo.tests('AWS::Storage | bucket requests', ['aws']) do

  tests('success') do

    @buckets_format = {
      'CreationDate'  => Time,
      'Name'          => String,
      'Owner'         => {
        'DisplayName' => String,
        'ID'          => String
      }
    }

    tests("#put_bucket('fog_bucket')").succeeds do
      AWS[:storage].put_bucket('fog_bucket')
    end

    tests("#get_service").formats('Buckets' => [@bucket_format]) do
      AWS[:storage].get_service.body
    end

    tests("#delete_bucket('fog_bucket')").succeeds do
      AWS[:storage].delete_bucket('fog_bucket')
    end

  end

  tests('failure') do

    tests("#delete_bucket('fog_not_a_bucket')").raises(Fog::Errors::NotFound) do
      AWS[:storage].delete_bucket('fog_not_a_bucket')
    end

    @bucket = AWS[:storage].directories.create('fog_nonempty')
    @file = @bucket.files.create(:key => 'foo', :body => 'bar')

    tests("#delete_bucket('fog_nonempty')").raises(Fog::Errors::Conflict) do
      AWS[:storage].delete_bucket('fog_nonempty')
    end

    @file.destroy
    @bucket.destroy

  end

end
