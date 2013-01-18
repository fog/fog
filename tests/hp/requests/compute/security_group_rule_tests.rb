Shindo.tests("Fog::Compute[:hp] | security group requests", ['hp']) do

  @security_group_rule_format = {
    'from_port'       => Integer,
    'group'           => Fog::Nullable::Hash,
    'ip_protocol'     => String,
    'to_port'         => Integer,
    'parent_group_id' => Integer,
    'ip_range'        => {
      'cidr' => String
    },
    'id'              => Integer
  }

  tests('success') do
    @security_group = Fog::Compute[:hp].security_groups.create(:name => 'fog_security_group', :description => 'tests group')

    tests("tcp #create_security_group_rule('#{@security_group.id}', 'tcp', '80', '80', '0.0.0.0/0'}')").formats({'security_group_rule' => @security_group_rule_format}) do
      data = Fog::Compute[:hp].create_security_group_rule(@security_group.id, 'tcp', '80', '80', '0.0.0.0/0').body
      @sec_group_rule_id_1 = data['security_group_rule']['id']
      data
    end

    tests("icmp #create_security_group_rule('#{@security_group.id}', 'icmp', '-1', '-1', '0.0.0.0/0'}')").formats({'security_group_rule' => @security_group_rule_format}) do
      data = Fog::Compute[:hp].create_security_group_rule(@security_group.id, 'icmp', '-1', '-1', '0.0.0.0/0').body
      @sec_group_rule_id_2 = data['security_group_rule']['id']
      data
    end

    tests("tcp #delete_security_group_rule('#{@sec_group_rule_id_1}')").succeeds do
      Fog::Compute[:hp].delete_security_group_rule(@sec_group_rule_id_1).body
    end

    tests("icmp #delete_security_group_rule('#{@sec_group_rule_id_2}')").succeeds do
      Fog::Compute[:hp].delete_security_group_rule(@sec_group_rule_id_2).body
    end

    @security_group.destroy

  end

  tests('failure') do

    tests("#create_security_group_rule(0, 'tcp', '80', '80', '0.0.0.0/0'}')").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].create_security_group_rule(0, 'tcp', '80', '80', '0.0.0.0/0')
    end

    tests("#delete_security_group_rule(0)").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].delete_security_group_rule(0)
    end

  end

end
