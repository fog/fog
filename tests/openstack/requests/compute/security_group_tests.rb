Shindo.tests('Fog::Compute[:openstack] | security group requests', ['openstack']) do
  @security_group = Hash.new
  @security_group_rule = Hash.new
  @security_group_format = {
    "id"          => Integer,
    "rules"       => Array,
    "tenant_id"   => String,
    "name"        => String,
    "description" => String
  }

  @security_group_rule_format = {
    "id"          => Integer,
    "from_port"   => Integer,
    "to_port"     => Integer,
    "ip_protocol" => String,
    "group"       => Hash,
    "ip_range"    => Hash,
    "parent_group_id" => Integer
  }

  tests('success') do
    tests('#create_security_group(name, description)').formats({"security_group" => @security_group_format}) do
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
      compute = Fog::Compute[:openstack]

      group_id = compute.list_security_groups.body['security_groups'].last['id']

      compute.delete_security_group(group_id)

      returns(false) {
        groups = compute.list_security_groups.body['security_groups']
        groups.any? { |group| group['id'] == group_id }
      }
    end
  end # tests('success')
end
