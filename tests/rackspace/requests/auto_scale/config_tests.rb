Shindo.tests('Fog::Rackspace::AutoScale | config_tests', ['rackspace', 'rackspace_autoscale']) do
  
  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  @group = service.create_group(LAUNCH_CONFIG_OPTIONS, GROUP_CONFIG_OPTIONS, POLICIES_OPTIONS).body['group']
  @group_id = @group['id']

  tests('success') do
    tests('#get group config').formats({"groupConfiguration" => GROUP_CONFIG_FORMAT}) do
      service.get_group_config(@group_id).body
    end
    tests('#update group config').formats(204) do
      data = service.update_group_config(@group_id, {
        'maxEntities' => 7, 
        'minEntities' => 1, 
        'metadata' => {}, 
        'name' => 'foo', 
        'cooldown' => 20}).data
      data[:status]
    end
  end

  tests('failure') do
    tests('#update group config').raises(Fog::Rackspace::AutoScale::BadRequest) do
      service.update_group_config(@group_id, {})
    end
    tests('#delete group config').raises(NoMethodError) do
      service.delete_group_config(123)
    end
    tests('#create group config').raises(NoMethodError) do
      service.create_group_config({})
    end
    tests('#update launch config').raises(Fog::Rackspace::AutoScale::BadRequest) do
      service.update_launch_config(@group_id, {})
    end
    tests('#delete launch config').raises(NoMethodError) do
      service.delete_launch_config(123)
    end
    tests('#create launch config').raises(NoMethodError) do
      service.create_launch_config({})
    end
  end

  # @group['scalingPolicies'].each do |p|
  #   service.delete_policy(@group_id, p['id'])
  # end

  # service.delete_group(@group_id)

end