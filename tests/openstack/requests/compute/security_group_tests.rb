Shindo.tests('Fog::Compute[:openstack] | security group requests', ['openstack']) do
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
    tests('#list_security_groups').formats({"security_groups" => [@security_group_format]}) do
      Fog::Compute[:openstack].list_security_groups.body
    end

    tests('#get_security_group(security_group_id)').formats({"security_group" => @security_group_format}) do
      Fog::Compute[:openstack].get_security_group(1).body
    end

    tests('#create_security_group(name, description)').formats({"security_groups" => [@security_group_format]}) do
      Fog::Compute[:openstack].create_security_group('test', 'this is from the test').body
    end

    tests('#create_security_group_rule(parent_group_id, ip_protocol, from_port, to_port, cidr, group_id=nil)').formats({"security_group_rule" => @security_group_rule_format}) do
      Fog::Compute[:openstack].create_security_group_rule(1, "tcp", 2, 3, "10.10.10.10/24").body
    end

    tests('#delete_security_group_rule(security_group_rule_id)').succeeds do
      Fog::Compute[:openstack].delete_security_group_rule(1)
    end

    tests('#delete_security_group(security_group_id)').succeeds do
      Fog::Compute[:openstack].delete_security_group(1)
    end
  end # tests('success')
end
