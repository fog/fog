Shindo.tests('AWS::Storage | object requests', ['aws']) do

  @directory = Fog::Storage[:aws].directories.create(:key => 'fogobjecttests')

  tests('success') do

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

    tests("#head_object('#{@directory.identity}', 'fog_object')").succeeds do
      Fog::Storage[:aws].head_object(@directory.identity, 'fog_object')
    end

    tests("#put_object_acl('#{@directory.identity}', 'fog_object', 'private')").succeeds do
      Fog::Storage[:aws].put_object_acl(@directory.identity, 'fog_object', 'private')
    end

    tests("#put_object_acl('#{@directory.identity}', 'fog_object', hash)").returns(true) do
      Fog::Storage[:aws].put_object_acl(@directory.identity, 'fog_object', {
        'Owner' => { 'ID' => "8a6925ce4adf5f21c32aa379004fef", 'DisplayName' => "mtd@amazon.com" },
        'AccessControlList' => [
          { 
            'Grantee' => { 'ID' => "8a6925ce4adf588a4532142d3f74dd8c71fa124b1ddee97f21c32aa379004fef", 'DisplayName' => "mtd@amazon.com" }, 
            'Permission' => "FULL_CONTROL" 
          }
        ]})
      Fog::Storage[:aws].get_object_acl(@directory.identity, 'fog_object').body == <<-BODY
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

    tests("#delete_object('#{@directory.identity}', 'fog_object')").succeeds do
      Fog::Storage[:aws].delete_object(@directory.identity, 'fog_object')
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

    tests("#put_object_acl('#{@directory.identity}', 'fog_object', 'invalid')").raises(Excon::Errors::BadRequest) do
      Fog::Storage[:aws].put_object_acl('#{@directory.identity}', 'fog_object', 'invalid')
    end

  end

  @directory.destroy

end
