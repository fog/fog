Shindo.tests('HP::Network | networking security groups collection', ['hp', 'networking', 'securitygroup']) do

  attributes = {:name => 'my_secgroup', :description => 'my sec group desc'}
  collection_tests(HP[:network].security_groups, attributes, true)

  tests('success') do

    attributes = {:name => 'fogsecgroup', :description => 'fog sec group desc'}
    @secgroup = HP[:network].security_groups.create(attributes)

    tests('#all(filter)').succeeds do
      secgroup = HP[:network].security_groups.all({:name => 'fogsecgroup'})
      secgroup.first.name == 'fogsecgroup'
    end

    @secgroup.destroy

  end

end
