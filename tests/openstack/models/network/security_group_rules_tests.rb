Shindo.tests('Fog::Network[:openstack] | security_group_rules collection', ['openstack']) do

  @secgroup   = Fog::Network[:openstack].security_groups.create({:name => "my_secgroup"})
  attributes  = {:security_group_id => @secgroup.id, :direction => "ingress"}
  collection_tests(Fog::Network[:openstack].security_group_rules, attributes, true)

  tests('success') do
    attributes = {
      :security_group_id  => @secgroup.id,
      :direction          => "ingress",
      :protocol           => "tcp",
      :port_range_min     => 22,
      :port_range_max     => 22,
      :remote_ip_prefix   => "0.0.0.0/0"
    }
    @secgrouprule = Fog::Network[:openstack].security_group_rules.create(attributes)

    tests('#all(filter)').succeeds do
      secgrouprule = Fog::Network[:openstack].security_group_rules.all({:direction => "ingress"})
      secgrouprule.first.direction == "ingress"
    end
    @secgrouprule.destroy
  end
  @secgroup.destroy
end
