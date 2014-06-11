Shindo.tests('Fog::Rackspace::AutoScale | webhook', ['rackspace', 'rackspace_autoscale']) do

  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  pending if Fog.mocking?

  begin
    group = service.groups.create({
      :policies => POLICIES_OPTIONS,
      :group_config => GROUP_CONFIG_OPTIONS,
      :launch_config => LAUNCH_CONFIG_OPTIONS
    })

    policy = group.policies.create({
      :name => "set group to 5 servers",
      :desired_capacity => 5,
      :cooldown => 1800,
      :type => "webhook",
      :group => group
    })

    options = {
      :name => 'webhook name',
      :metadata => {
        'owner' => 'me'
      },
      :group => group,
      :policy => policy
    }

    model_tests(policy.webhooks, options, false) do
      tests('#execution_url').succeeds do
        @instance.execution_url
      end
    end
  ensure
    policy.destroy if policy
    deactive_auto_scale_group(group)
    group.destroy if group
  end

end
