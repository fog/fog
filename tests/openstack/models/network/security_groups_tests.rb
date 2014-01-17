Shindo.tests('Fog::Network[:openstack] | security_groups collection', ['openstack']) do

  attributes = {:name => "my_secgroup", :description => "my sec group desc"}
  collection_tests(Fog::Network[:openstack].security_groups, attributes, true)

  tests('success') do
    attributes = {:name => "fogsecgroup", :description => "fog sec group desc"}
    @secgroup = Fog::Network[:openstack].security_groups.create(attributes)

    tests('#all(filter)').succeeds do
      secgroup = Fog::Network[:openstack].security_groups.all({:name => "fogsecgroup"})
      secgroup.first.name == "fogsecgroup"
    end
    @secgroup.destroy
  end
end
