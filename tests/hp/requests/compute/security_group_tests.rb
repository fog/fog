Shindo.tests("Fog::Compute[:hp] | security group requests", ['hp']) do

  @security_groups_format = {
    'security_groups' => [{
      'rules'       => [Fog::Nullable::Hash],
      'tenant_id'   => String,
      'id'          => Integer,
      'name'        => String,
      'description' => String
    }]
  }

  @security_group_format = {
    'rules'       => [Fog::Nullable::Hash],
    'tenant_id'   => String,
    'id'          => Integer,
    'name'        => String,
    'description' => String
  }

  tests('success') do

    tests("#create_security_group('fog_security_group', 'tests group')").formats({'security_group' => @security_group_format}) do
      data = Fog::Compute[:hp].create_security_group('fog_security_group', 'tests group').body
      @sec_group_id = data['security_group']['id']
      data
    end

    tests("#get_security_group('#{@sec_group_id}')").formats({'security_group' => @security_group_format}) do
      Fog::Compute[:hp].get_security_group(@sec_group_id).body
    end

    tests("#list_security_groups").formats(@security_groups_format) do
      Fog::Compute[:hp].list_security_groups.body
    end

    tests("#delete_security_group('#{@sec_group_id}')").succeeds do
      Fog::Compute[:hp].delete_security_group(@sec_group_id).body
    end

  end

  tests('failure') do

    @security_group = Fog::Compute[:hp].security_groups.create(:name => 'fog_security_group_fail', :description => 'tests group')

    tests("duplicate #create_security_group(#{@security_group.name}, #{@security_group.description})").raises(Excon::Errors::BadRequest) do
      Fog::Compute[:hp].create_security_group(@security_group.name, @security_group.description)
    end

    tests("#get_security_group(0)").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].get_security_group(0)
    end

    tests("#delete_security_group(0)").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].delete_security_group(0)
    end

    @security_group.destroy

  end

end
