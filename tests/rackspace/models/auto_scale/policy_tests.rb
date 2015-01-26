Shindo.tests('Fog::Rackspace::AutoScale | policy', ['rackspace', 'rackspace_autoscale']) do

  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  pending if Fog.mocking?

  begin
    group = service.groups.create({
      :policies => POLICIES_OPTIONS,
      :group_config => GROUP_CONFIG_OPTIONS,
      :launch_config => LAUNCH_CONFIG_OPTIONS
    })

    options = {
      :name => "policy 2",
      :change => 1,
      :cooldown => 100,
      :type => 'webhook',
      :group => group
    }

    model_tests(group.policies, options, false) do
      tests('#execute').succeeds do
        @instance.execute
      end
      tests('#webhooks').succeeds do
        @instance.webhooks
      end
    end
  ensure
    deactive_auto_scale_group(group)
    group.destroy if group
  end

end
