Shindo.tests('HP::Network | networking security group model', ['hp', 'networking', 'securitygroup']) do

  model_tests(HP[:network].security_groups, {:name => 'fogsecgroup'}, true)

  tests('success') do

    tests('#create').succeeds do
      attributes = {:name => 'my_secgroup', :description => 'my sec group desc'}
      @secgroup = HP[:network].security_groups.create(attributes)
      @secgroup.wait_for { ready? } unless Fog.mocking?
      !@secgroup.id.nil?
    end

    tests('#destroy').succeeds do
      @secgroup.destroy
    end

  end

end
