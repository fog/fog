Shindo.tests('Fog::Compute[:openstack] | security group requests', ['openstack']) do
  @security_group = Hash.new
  @security_group_rule = Hash.new
  @security_group_format = {
    "rules" => Array,
    "tenant_id" => String,
    "id" => Integer,
    "name" => String,
    "description" => String
  }

  @security_group_rule_format = {
    "from_port" => Integer,
    "group"     => Hash,
    "ip_protocol" => String,
    "to_port" => Integer,
    "parent_group_id" => Integer,
    "ip_range" => Hash,
    "id" => Integer
  }

  tests('success') do
    tests('#create_security_group(name, description)').formats({"security_group" => [@security_group_format]}) do
      Fog::Compute[:openstack].create_security_group('from_shindo_test', 'this is from the shindo test').body
    end

    tests('#create_security_group_rule(parent_group_id, ip_protocol, from_port, to_port, cidr, group_id=nil)').formats({"security_group_rule" => @security_group_rule_format}) do
      parent_group_id = Fog::Compute[:openstack].list_security_groups.body['security_groups'].last['id']
      Fog::Compute[:openstack].create_security_group_rule(parent_group_id, "tcp", 2222, 3333, "20.20.20.20/24").body
    end

    tests('#list_security_groups').formats({"security_groups" => [@security_group_format]}) do
      Fog::Compute[:openstack].list_security_groups.body
    end

    tests('#get_security_group(security_group_id)').formats({"security_group" => @security_group_format}) do
      group_id = Fog::Compute[:openstack].list_security_groups.body['security_groups'].last['id']
      Fog::Compute[:openstack].get_security_group(group_id).body
    end

    tests('#delete_security_group_rule(security_group_rule_id)').succeeds do
      security_group_rule_id = Fog::Compute[:openstack].list_security_groups.body['security_groups'].last['rules'].last['id']
      Fog::Compute[:openstack].delete_security_group_rule(security_group_rule_id)
    end

    tests('#delete_security_group(security_group_id)').succeeds do
      group_id = Fog::Compute[:openstack].list_security_groups.body['security_groups'].last['id']
      Fog::Compute[:openstack].delete_security_group(group_id)
    end
  end # tests('success')
end
