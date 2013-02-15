Shindo.tests('AWS::Storage | object requests', ['aws']) do
  @directory = Fog::Storage[:aws].directories.create(:key => 'fogobjecttests-' + Time.now.to_i.to_s(32))
  @aws_owner = Fog::Storage[:aws].get_bucket_acl(@directory.key).body['Owner']

  tests('success') do

    @multiple_delete_format = {
      'DeleteResult' => [{
        'Deleted' => {
          'Key' => String
        }
      }]
    }

    tests("#put_object('#{@directory.identity}', 'fog_object', lorem_file)").succeeds do
      Fog::Storage[:aws].put_object(@directory.identity, 'fog_object', lorem_file)
    end

    tests("#copy_object('#{@directory.identity}', 'fog_object', '#{@directory.identity}', 'fog_other_object')").succeeds do
      Fog::Storage[:aws].copy_object(@directory.identity, 'fog_object', @directory.identity, 'fog_other_object')
    end

    @directory.files.get('fog_other_object').destroy

    tests("#get_object('#{@directory.identity}', 'fog_object')").returns(lorem_file.read) do
      Fog::Storage[:aws].get_object(@directory.identity, 'fog_object').body
    end

    tests("#get_object('#{@directory.identity}', 'fog_object', &block)").returns(lorem_file.read) do
      data = ''
      Fog::Storage[:aws].get_object(@directory.identity, 'fog_object') do |chunk, remaining_bytes, total_bytes|
        data << chunk
      end
      data
    end

    tests("#get_object('#{@directory.identity}', 'fog_object', {'Range' => 'bytes=0-20'})").returns(lorem_file.read[0..20]) do
      Fog::Storage[:aws].get_object(@directory.identity, 'fog_object', {'Range' => 'bytes=0-20'}).body
    end

    tests("#get_object('#{@directory.identity}', 'fog_object', {'Range' => 'bytes=0-0'})").returns(lorem_file.read[0..0]) do
      Fog::Storage[:aws].get_object(@directory.identity, 'fog_object', {'Range' => 'bytes=0-0'}).body
    end

    tests("#head_object('#{@directory.identity}', 'fog_object')").succeeds do
      Fog::Storage[:aws].head_object(@directory.identity, 'fog_object')
    end

    tests("#put_object_acl('#{@directory.identity}', 'fog_object', 'private')").succeeds do
      Fog::Storage[:aws].put_object_acl(@directory.identity, 'fog_object', 'private')
    end

    acl = {
      'Owner' => @aws_owner,
      'AccessControlList' => [
        {
          'Grantee' => @aws_owner,
          'Permission' => "FULL_CONTROL"
        }
      ]}
    tests("#put_object_acl('#{@directory.identity}', 'fog_object', hash with id)").returns(acl) do
      Fog::Storage[:aws].put_object_acl(@directory.identity, 'fog_object', acl)
      Fog::Storage[:aws].get_object_acl(@directory.identity, 'fog_object').body
    end

    tests("#put_object_acl('#{@directory.identity}', 'fog_object', hash with email)").returns({
        'Owner' => @aws_owner,
        'AccessControlList' => [
          {
            'Grantee' => { 'ID' => 'f62f0218873cfa5d56ae9429ae75a592fec4fd22a5f24a20b1038a7db9a8f150', 'DisplayName' => 'mtd' },
            'Permission' => "FULL_CONTROL"
          }
        ]}) do
      pending if Fog.mocking?
      Fog::Storage[:aws].put_object_acl(@directory.identity, 'fog_object', {
        'Owner' => @aws_owner,
        'AccessControlList' => [
          {
            'Grantee' => { 'EmailAddress' => 'mtd@amazon.com' },
            'Permission' => "FULL_CONTROL"
          }
        ]})
      Fog::Storage[:aws].get_object_acl(@directory.identity, 'fog_object').body
    end

    acl = {
      'Owner' => @aws_owner,
      'AccessControlList' => [
        {
          'Grantee' => { 'URI' => 'http://acs.amazonaws.com/groups/global/AllUsers' },
          'Permission' => "FULL_CONTROL"
        }
      ]}
    tests("#put_object_acl('#{@directory.identity}', 'fog_object', hash with uri)").returns(acl) do
      Fog::Storage[:aws].put_object_acl(@directory.identity, 'fog_object', acl)
      Fog::Storage[:aws].get_object_acl(@directory.identity, 'fog_object').body
    end

    tests("#delete_object('#{@directory.identity}', 'fog_object')").succeeds do
      Fog::Storage[:aws].delete_object(@directory.identity, 'fog_object')
    end

    tests("#get_object_http_url('#{@directory.identity}', 'fog_object', expiration timestamp)").returns(true) do
      object_url = Fog::Storage[:aws].get_object_http_url(@directory.identity, 'fog_object', (Time.now + 60))
      (object_url =~ /http:\/\/#{Regexp.quote(@directory.identity)}\.s3\.amazonaws\.com\/fog_object/) != nil
    end

    tests("delete_multiple_objects('#{@directory.identity}', ['fog_object', 'fog_other_object'])").formats(@multiple_delete_format) do
      Fog::Storage[:aws].delete_multiple_objects(@directory.identity, ['fog_object', 'fog_other_object']).body
    end

  end

  tests('failure') do

    tests("#put_object('fognonbucket', 'fog_non_object', lorem_file)").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].put_object('fognonbucket', 'fog_non_object', lorem_file)
    end

    tests("#copy_object('fognonbucket', 'fog_object', '#{@directory.identity}', 'fog_other_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].copy_object('fognonbucket', 'fog_object', @directory.identity, 'fog_other_object')
    end

    tests("#copy_object('#{@directory.identity}', 'fog_non_object', '#{@directory.identity}', 'fog_other_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].copy_object(@directory.identity, 'fog_non_object', @directory.identity, 'fog_other_object')
    end

    tests("#copy_object('#{@directory.identity}', 'fog_object', 'fognonbucket', 'fog_other_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].copy_object(@directory.identity, 'fog_object', 'fognonbucket', 'fog_other_object')
    end

    tests("#get_object('fognonbucket', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].get_object('fognonbucket', 'fog_non_object')
    end

    tests("#get_object('#{@directory.identity}', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].get_object(@directory.identity, 'fog_non_object')
    end

    tests("#head_object('fognonbucket', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].head_object('fognonbucket', 'fog_non_object')
    end

    tests("#head_object('#{@directory.identity}', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].head_object(@directory.identity, 'fog_non_object')
    end

    tests("#delete_object('fognonbucket', 'fog_non_object')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].delete_object('fognonbucket', 'fog_non_object')
    end

    tests("#delete_multiple_objects('fognonbucket', ['fog_non_object'])").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Storage[:aws].delete_multiple_objects('fognonbucket', ['fog_non_object'])
    end

    tests("#put_object_acl('#{@directory.identity}', 'fog_object', 'invalid')").raises(Excon::Errors::BadRequest) do
      Fog::Storage[:aws].put_object_acl('#{@directory.identity}', 'fog_object', 'invalid')
    end

  end

  @directory.destroy

end
