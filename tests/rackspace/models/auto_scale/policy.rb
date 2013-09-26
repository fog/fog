Shindo.tests('Fog::Rackspace::AutoScale | policy', ['rackspace', 'rackspace_autoscale']) do
  
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
    :type => 'webhook',
    :group_id => group.id
  }

  begin
    model_tests(group.policies, options, false) do
      tests('#webhooks').succeeds do
        @instance.webhooks
      end
    end
  ensure
    group.destroy
  end

end