Shindo.tests('HP::Network | networking security group rule model', ['hp', 'networking', 'securitygroup']) do

  @secgroup = HP[:network].security_groups.create({:name => 'fogsecgroup'})

  attributes = {:security_group_id => @secgroup.id, :direction => 'ingress'}
  model_tests(HP[:network].security_group_rules, attributes, true)

  tests('success') do

    tests('#create').succeeds do
      attributes = {:security_group_id => @secgroup.id, :direction => 'ingress', :protocol => 'tcp',
        :port_range_min => 22, :port_range_max => 22, :remote_ip_prefix => '0.0.0.0/0'}
      @secgrouprule = HP[:network].security_group_rules.create(attributes)
      @secgrouprule.wait_for { ready? } unless Fog.mocking?
      !@secgrouprule.id.nil?
    end

    tests('#destroy').succeeds do
      @secgrouprule.destroy
    end

  end

  @secgroup.destroy
end
