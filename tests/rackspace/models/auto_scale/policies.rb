Shindo.tests('Fog::Rackspace::AutoScale | policies', ['rackspace', 'rackspace_autoscale']) do 
  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  group = service.groups.create({
    :policies => POLICIES_OPTIONS,
    :group_config => GROUP_CONFIG_OPTIONS,
    :launch_config => LAUNCH_CONFIG_OPTIONS
  })

  options = {
    :name => "policy 2",
    :change => 5,
    :cooldown => 100,
    :type => 'webhook'
  }

  begin
    collection_tests(group.policies, options, false)
  ensure
    group.destroy
  end
end