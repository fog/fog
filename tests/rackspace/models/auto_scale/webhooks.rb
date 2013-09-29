Shindo.tests('Fog::Rackspace::AutoScale | webhooks', ['rackspace', 'rackspace_autoscale']) do 
  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  group = service.groups.create({
    :policies => POLICIES_OPTIONS,
    :group_config => GROUP_CONFIG_OPTIONS,
    :launch_config => LAUNCH_CONFIG_OPTIONS
  })

  policy = group.policies.create({
    :name => "policy 2",
    :change => 5,
    :cooldown => 100,
    :type => 'webhook',
    :group_id => group.id
  })

  options = {:name => 'New webhook', :group_id => group.id, :policy_id => policy.id}

  begin
    collection_tests(policy.webhooks, options, false)
  ensure
    policy.destroy
    group.destroy
  end

end