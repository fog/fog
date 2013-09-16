Shindo.tests('Fog::Rackspace::AutoScale | group', ['rackspace', 'rackspace_autoscale']) do
	
	service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

	options = {
		:name => "fog_#{Time.now.to_i.to_s}", 
		:policies => POLICIES_OPTIONS, 
		:launch_config => LAUNCH_CONFIG_OPTIONS, 
		:group_config => GROUP_CONFIG_OPTIONS
	}


	model_tests(service.groups, options, false) do
		tests('#policies').succeeds do
			@instance.policies
		end
	end

end