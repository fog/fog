Shindo.tests('Fog::Rackspace::AutoScale | policy_tests', ['rackspace', 'rackspace_autoscale']) do

  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  begin
    @group_id = service.create_group(LAUNCH_CONFIG_OPTIONS, GROUP_CONFIG_OPTIONS, POLICIES_OPTIONS).body['group']['id']

    tests('success') do
      tests('#list policies').formats(POLICIES_FORMAT) do
        service.list_policies(@group_id).body['policies']
      end
      tests('#create_policy').returns(201) do
        response = service.create_policy(@group_id, POLICY_OPTIONS)
        @policy_id = response.body['policies'][0]['id']
        response.status
      end

      tests('#get_policy').formats(POLICY_FORMAT) do
        response = service.get_policy(@group_id, @policy_id)
        response.body['policy']
      end

      tests('#execute_policy').returns(202) do
        service.execute_policy(@group_id, @policy_id).status
      end

      tests('#update_policy').returns(204) do
        response = service.update_policy(@group_id, @policy_id, {
          'name' => 'foo',
          'changePercent' => 1,
          'type' => 'webhook',
          'cooldown' => 100
        })
        response.status
      end

      tests('#delete_policy').returns(204) do
        response = service.delete_policy(@group_id, @policy_id)
        response.status
      end
    end
  ensure
    group = service.groups.get(@group_id)
    deactive_auto_scale_group(group)
    group.destroy
  end

  tests('failure') do
    tests('#create policy').raises(Fog::Rackspace::AutoScale::BadRequest) do
      service.create_policy(@group_id, {})
    end

    tests('#get policy').raises(Fog::Rackspace::AutoScale::NotFound) do
      service.get_policy(@group_id, 123)
    end

    tests('#update policy').raises(Fog::Rackspace::AutoScale::BadRequest) do
      service.update_policy(@group_id, 123, {})
    end

    tests('#execute policy').raises(Fog::Rackspace::AutoScale::NotFound) do
      service.execute_policy(@group_id, 123)
    end

    tests('#delete policy').raises(Fog::Rackspace::AutoScale::NotFound) do
      service.delete_policy(@group_id, 123)
    end
  end

end
