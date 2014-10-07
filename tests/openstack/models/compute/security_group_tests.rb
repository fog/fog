Shindo.tests("Fog::Compute[:openstack] | security_group", ['openstack']) do
  tests('success') do
    begin
      fog = Fog::Compute[:openstack]

      security_group = fog.security_groups.create(
        :name        => 'my_group',
        :description => 'my group'
      )

      tests('#create').succeeds do
        security_group = fog.security_groups.create(
          :name        => 'my_group',
          :description => 'my group'
        )

        returns('my_group') { security_group.name }
        returns('my group') { security_group.description }
        returns([])         { security_group.security_group_rules }
        returns(true, "Tenant Id is not nil")       { security_group.tenant_id != nil }
      end

      tests('#rules').succeeds do
        tests("#create").succeeds do
          rules_count = security_group.security_group_rules.count
          rule        = security_group.security_group_rules.create(
            :parent_group_id => security_group.id,
            :ip_protocol     => 'tcp',
            :from_port       => 1234,
            :to_port         => 1234,
            :ip_range        => { "cidr" => "0.0.0.0/0" }
          )
          returns(true, "added security group rule") { security_group.security_group_rules.count == (rules_count + 1) }
          security_group_rule = security_group.security_group_rules.find { |r| r.id == rule.id }
          returns(true, "security group rule has rule attributes") { security_group_rule.attributes == rule.attributes }
        end

        tests("#destroy").succeeds do
          rule        = security_group.security_group_rules.create(
            :parent_group_id => security_group.id,
            :ip_protocol     => 'tcp',
            :from_port       => 1234,
            :to_port         => 1234,
            :ip_range        => { "cidr" => "0.0.0.0/0" }
          )
          rule.destroy
          returns(true, "successfully destroyed rule") { rule.reload == nil }
        end
      end
    ensure
      security_group.destroy if security_group
    end
  end
end
