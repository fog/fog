Shindo.tests('Fog::Rackspace::AutoScale | groups', ['rackspace', 'rackspace_autoscale']) do 
  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  options = {
    :policies => POLICIES_OPTIONS,
    :group_config => GROUP_CONFIG_OPTIONS,
    :launch_config => LAUNCH_CONFIG_OPTIONS
  }

  collection_tests(service.groups, options, false)

end