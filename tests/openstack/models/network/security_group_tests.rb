Shindo.tests('Fog::Network[:openstack] | security_group model', ['openstack']) do

  model_tests(Fog::Network[:openstack].security_groups, {:name => "fogsecgroup"}, true)

  tests('success') do
    tests('#create').succeeds do
      attributes = {:name => "my_secgroup", :description => "my sec group desc"}
      @secgroup = Fog::Network[:openstack].security_groups.create(attributes)
      @secgroup.wait_for { ready? } unless Fog.mocking?
      !@secgroup.id.nil?
    end

    tests('#destroy').succeeds do
      @secgroup.destroy
    end
  end
end
