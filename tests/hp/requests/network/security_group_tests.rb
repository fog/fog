Shindo.tests('HP::Network | networking security group requests', ['hp', 'networking', 'securitygroup']) do

  @security_group_format = {
    'id'                    => String,
    'name'                  => String,
    'description'           => String,
    'tenant_id'             => String,
    'security_group_rules'  => [Hash]
  }

  tests('success') do

    @sec_group_id = nil

    tests("#create_security_group('fog_security_group', 'tests group')").formats(@security_group_format) do
      attributes = {:name => 'fog_security_group', :description => 'tests group'}
      data = HP[:network].create_security_group(attributes).body['security_group']
      @sec_group_id = data['id']
      data
    end

    tests("#get_security_group('#{@sec_group_id}')").formats(@security_group_format) do
      HP[:network].get_security_group(@sec_group_id).body['security_group']
    end

    tests("#list_security_groups").formats('security_groups' => [@security_group_format]) do
      HP[:network].list_security_groups.body
    end

    tests("#delete_security_group('#{@sec_group_id}')").succeeds do
      HP[:network].delete_security_group(@sec_group_id)
    end

  end

  tests('failure') do

    tests("#get_security_group(0)").raises(Fog::HP::Network::NotFound) do
      HP[:network].get_security_group(0)
    end

    tests("#delete_security_group(0)").raises(Fog::HP::Network::NotFound) do
      HP[:network].delete_security_group(0)
    end

  end

end
