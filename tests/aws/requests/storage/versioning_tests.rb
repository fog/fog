Shindo.tests('Fog::Storage[:aws] | versioning', [:aws]) do
  tests('success') do
    tests("#put_bucket_versioning") do
      @aws_bucket_name = 'fogbuckettests-' + Fog::Mock.random_hex(16)

      before do
        Fog::Storage[:aws].put_bucket(@aws_bucket_name)
      end

      after do
        Fog::Storage[:aws].delete_bucket(@aws_bucket_name)
        @aws_bucket_name = 'fogbuckettests-' + Fog::Mock.random_hex(16)
      end

      tests("#put_bucket_versioning('#{@aws_bucket_name}', 'Enabled')").succeeds do
        Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'Enabled')
      end

      tests("#put_bucket_versioning('#{@aws_bucket_name}', 'Suspended')").succeeds do
        Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'Suspended')
      end
    end

    tests("#get_bucket_versioning('#{@aws_bucket_name}')") do
      @aws_bucket_name = 'fogbuckettests-' + Fog::Mock.random_hex(16)

      before do
        Fog::Storage[:aws].put_bucket(@aws_bucket_name)
      end

      after do
        Fog::Storage[:aws].delete_bucket(@aws_bucket_name)
        @aws_bucket_name = 'fogbuckettests-' + Fog::Mock.random_hex(16)
      end

      tests("#get_bucket_versioning('#{@aws_bucket_name}') without versioning").returns({}) do
        Fog::Storage[:aws].get_bucket_versioning(@aws_bucket_name).body['VersioningConfiguration']
      end

      tests("#get_bucket_versioning('#{@aws_bucket_name}') with versioning enabled").returns('Enabled') do
        Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'Enabled')
        Fog::Storage[:aws].get_bucket_versioning(@aws_bucket_name).body['VersioningConfiguration']['Status']
      end

      tests("#get_bucket_versioning('#{@aws_bucket_name}') with versioning suspended").returns('Suspended') do
        Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'Enabled')
        Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'Suspended')
        Fog::Storage[:aws].get_bucket_versioning(@aws_bucket_name).body['VersioningConfiguration']['Status']
      end
    end
  end

  tests('failure') do
    @aws_bucket_name = 'fogbuckettests-' + Fog::Mock.random_hex(16)
    Fog::Storage[:aws].put_bucket(@aws_bucket_name)

    tests("#put_bucket_versioning('#{@aws_bucket_name}', 'bad_value')").raises(Excon::Errors::BadRequest) do
      Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'bad_value')
    end

    tests("#put_bucket_versioning('fognonbucket', 'Enabled')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].put_bucket_versioning('fognonbucket', 'Enabled')
    end

    tests("#get_bucket_versioning('fognonbucket')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].get_bucket_versioning('fognonbucket')
    end
  end

  # don't keep the bucket around
  Fog::Storage[:aws].delete_bucket(@aws_bucket_name) rescue nil
end