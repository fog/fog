Shindo.tests('Fog::Rackspace::AutoScale | webhooks', ['rackspace', 'rackspace_autoscale']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  begin
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
      :group => group
    })

    options = {:name => 'New webhook', :group => group, :policy => policy }
    collection_tests(policy.webhooks, options, false)
  ensure
    policy.destroy if policy
    deactive_auto_scale_group(group)
    group.destroy if group
  end

end
