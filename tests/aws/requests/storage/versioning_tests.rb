def clear_bucket
  Fog::Storage[:aws].get_bucket_object_versions(@aws_bucket_name).body['Versions'].each do |version|
    object = version[version.keys.first]
    Fog::Storage[:aws].delete_object(@aws_bucket_name, object['Key'], 'versionId' => object['VersionId'])
  end
end

def create_versioned_bucket
  @aws_bucket_name = 'fogbuckettests-' + Fog::Mock.random_hex(16)
  Fog::Storage[:aws].put_bucket(@aws_bucket_name)
  Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'Enabled')
end

def delete_bucket
  Fog::Storage[:aws].get_bucket_object_versions(@aws_bucket_name).body['Versions'].each do |version|
    object = version[version.keys.first]
    Fog::Storage[:aws].delete_object(@aws_bucket_name, object['Key'], 'versionId' => object['VersionId'])
  end

  Fog::Storage[:aws].delete_bucket(@aws_bucket_name)
end

Shindo.tests('Fog::Storage[:aws] | versioning', [:aws]) do
  tests('success') do
    tests("#put_bucket_versioning") do
      @aws_bucket_name = 'fogbuckettests-' + Fog::Mock.random_hex(16)
      Fog::Storage[:aws].put_bucket(@aws_bucket_name)

      tests("#put_bucket_versioning('#{@aws_bucket_name}', 'Enabled')").succeeds do
        Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'Enabled')
      end

      tests("#put_bucket_versioning('#{@aws_bucket_name}', 'Suspended')").succeeds do
        Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'Suspended')
      end

      delete_bucket
    end

    tests("#get_bucket_versioning('#{@aws_bucket_name}')") do
      @aws_bucket_name = 'fogbuckettests-' + Fog::Mock.random_hex(16)
      Fog::Storage[:aws].put_bucket(@aws_bucket_name)

      tests("#get_bucket_versioning('#{@aws_bucket_name}') without versioning").returns({}) do
        Fog::Storage[:aws].get_bucket_versioning(@aws_bucket_name).body['VersioningConfiguration']
      end

      tests("#get_bucket_versioning('#{@aws_bucket_name}') with versioning enabled").returns('Enabled') do
        Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'Enabled')
        Fog::Storage[:aws].get_bucket_versioning(@aws_bucket_name).body['VersioningConfiguration']['Status']
      end

      tests("#get_bucket_versioning('#{@aws_bucket_name}') with versioning suspended").returns('Suspended') do
        Fog::Storage[:aws].put_bucket_versioning(@aws_bucket_name, 'Suspended')
        Fog::Storage[:aws].get_bucket_versioning(@aws_bucket_name).body['VersioningConfiguration']['Status']
      end

      delete_bucket
    end

    tests("#get_bucket_object_versions('#{@aws_bucket_name}')") do
      @versions_format = {
        'IsTruncated'     => Fog::Boolean,
        'MaxKeys'         => Integer,
        'Name'            => String,
        'Prefix'          => NilClass,
        'KeyMarker'       => NilClass,
        'VersionIdMarker' => NilClass,
        'Versions'    => [{
          'DeleteMarker' => {
            'Key'           => String,
            'LastModified'  => Time,
            'Owner' => {
              'DisplayName' => String,
              'ID'          => String
            },
            'IsLatest'     => Fog::Boolean,
            'VersionId'    => String
          },
          'Version' => {
            'ETag'          => String,
            'Key'           => String,
            'LastModified'  => Time,
            'Owner' => {
              'DisplayName' => String,
              'ID'          => String
            },
            'Size' => Integer,
            'StorageClass' => String,
            'IsLatest'     => Fog::Boolean,
            'VersionId'    => String
          }
        }]
      }

      create_versioned_bucket

      file = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'y', :key => 'x')
      file.destroy

#      tests("#get_bucket_object_versions('#{@aws_bucket_name}')").formats(@versions_format) do
#        Fog::Storage[:aws].get_bucket_object_versions(@aws_bucket_name).body
#      end

      clear_bucket

      before do
        @versions = Fog::Storage[:aws].get_bucket_object_versions(@aws_bucket_name)
      end


      create_versioned_bucket

      v1 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'a',    :key => 'file')
      v2 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'ab',   :key => 'file')
      v3 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'abc',  :key => 'file')
      v4 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'abcd', :key => 'file')

      tests("versions").returns([v4.version, v3.version, v2.version, v1.version]) do
        @versions.body['Versions'].collect {|v| v['Version']['VersionId']}
      end

      tests("version sizes").returns([4, 3, 2, 1]) do
        @versions.body['Versions'].collect {|v| v['Version']['Size']}
      end

      tests("latest version").returns(v4.version) do
        latest = @versions.body['Versions'].find {|v| v['Version']['IsLatest']}
        latest['Version']['VersionId']
      end

      delete_bucket
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

    tests("#get_bucket_object_versions('fognonbucket')").raises(Excon::Errors::NotFound) do
        Fog::Storage[:aws].get_bucket_object_versions('fognonbucket')
      end
  end

  # don't keep the bucket around
  Fog::Storage[:aws].delete_bucket(@aws_bucket_name) rescue nil
end
