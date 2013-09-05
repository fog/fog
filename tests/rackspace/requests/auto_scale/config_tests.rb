Shindo.tests('Fog::Rackspace::AutoScale | config_tests', ['rackspace', 'rackspace_autoscale']) do
  
  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  @launch_config = begin 
    Fog::Rackspace::AutoScale::LaunchConfig.new({
      :service => @service,
      :group   => self
    }).merge_attributes(LAUNCH_CONFIG_OPTIONS) 
  end

  @group_config = begin 
    Fog::Rackspace::AutoScale::GroupConfig.new({
      :service => @service,
      :group   => self
    }).merge_attributes(GROUP_CONFIG_OPTIONS) 
  end

  @group_id = service.create_group(@launch_config, @group_config, POLICIES_OPTIONS).body['group']['id']

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

  # If you execute a DELETE, it returns a 403 and says there are "entities" attached to the group. What?
  #service.delete_group(@group_id)

end