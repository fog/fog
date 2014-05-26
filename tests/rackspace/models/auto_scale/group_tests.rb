Shindo.tests('Fog::Rackspace::AutoScale | group', ['rackspace', 'rackspace_autoscale']) do

	service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

	options = {
		:name => "fog_#{Time.now.to_i.to_s}",
		:policies => POLICIES_OPTIONS,
		:launch_config => LAUNCH_CONFIG_OPTIONS,
		:group_config => GROUP_CONFIG_OPTIONS
	}

	model_tests(service.groups, options, false) do
    pending if Fog.mocking?
		tests('#policies').succeeds do
			@instance.policies
		end

		tests('#launch_config').succeeds do
      @instance.launch_config
	  end

	  tests('#group_config').succeeds do
      @instance.group_config
    end

    tests('#state').succeeds do
      @instance.state
    end

    tests('deactive scaling group').succeeds do
      deactive_auto_scale_group(@instance)
    end
	end

end
