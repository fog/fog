Shindo.tests('HP::Network | networking security group rule requests', ['hp', 'networking', 'securitygroup']) do

  @security_group_rule_format = {
    'id'                    => String,
    'remote_group_id'       => Fog::Nullable::String,
    'direction'             => String,
    'remote_ip_prefix'      => Fog::Nullable::String,
    'protocol'              => Fog::Nullable::String,
    'ethertype'             => String,
    'port_range_max'        => Fog::Nullable::Integer,
    'port_range_min'        => Fog::Nullable::Integer,
    'security_group_id'     => String,
    'tenant_id'             => String
  }

  tests('success') do

    attributes = {:name => 'my_security_group', :description => 'tests group'}
    data = HP[:network].create_security_group(attributes).body['security_group']
    @sec_group_id = data['id']

    @sec_group_rule_id = nil

    tests("#create_security_group_rule(#{@sec_group_id}, 'ingress', attributes)").formats(@security_group_rule_format) do
      attributes = {:remote_ip_prefix => '0.0.0.0/0', :protocol => 'tcp', :port_range_min => 22, :port_range_max => 22}
      data = HP[:network].create_security_group_rule(@sec_group_id, 'ingress', attributes).body['security_group_rule']
      @sec_group_rule_id = data['id']
      data
    end

    tests("#get_security_group_rule('#{@sec_group_rule_id}')").formats(@security_group_rule_format) do
      HP[:network].get_security_group_rule(@sec_group_rule_id).body['security_group_rule']
    end

    tests("#list_security_group_rules").formats('security_group_rules' => [@security_group_rule_format]) do
      HP[:network].list_security_group_rules.body
    end

    tests("#delete_security_group_rule('#{@sec_group_rule_id}')").succeeds do
      HP[:network].delete_security_group_rule(@sec_group_rule_id)
    end

  end

  tests('failure') do

    tests('#get_security_group_rule(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].get_security_group_rule(0)
    end

    tests('#delete_security_group_rule(0)').raises(Fog::HP::Network::NotFound) do
      HP[:network].delete_security_group_rule(0)
    end

  end

  HP[:network].delete_security_group(@sec_group_id)
end
