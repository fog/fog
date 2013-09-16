Shindo.tests('Fog::Rackspace::AutoScale | webhook_tests', ['rackspace', 'rackspace_autoscale']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  @group_id = service.create_group(LAUNCH_CONFIG_OPTIONS, GROUP_CONFIG_OPTIONS, POLICIES_OPTIONS).body['group']['id']
  @policy_id = service.create_policy(@group_id, POLICY_OPTIONS).body['policies'][0]['id']

  tests('success') do
    tests('#create webhook').formats(201) do
      response = service.create_webhook(@group_id, @policy_id, WEBHOOK_OPTIONS)
      @webhook_id = response.body['webhooks'][0]['id']
      response.data[:status]
    end

    tests('#view webhook').formats(WEBHOOK_FORMAT) do
      response = service.get_webhook(@group_id, @policy_id, @webhook_id)
      response.body['webhook']
    end

    tests('#update webhook').formats(204) do
      response = service.update_webhook(@group_id, @policy_id, @webhook_id, {'name' => 'new', 'metadata' => {}} )
      response.data[:status]
    end

    tests('#delete webhook').formats(204) do
      response = service.delete_webhook(@group_id, @policy_id, @webhook_id)
      response.data[:status]
    end
  end

  tests('failure') do
    tests('#create webhook').raises(Fog::Rackspace::AutoScale::BadRequest) do
      service.create_webhook(@group_id, @policy_id, {})
    end

    tests('#view webhook').raises(Fog::Rackspace::AutoScale::NotFound) do
      service.get_webhook(@group_id, @policy_id, 123)
    end

    tests('#update webhook').raises(Fog::Rackspace::AutoScale::BadRequest) do
      service.update_webhook(@group_id, @policy_id, @webhook_id, {})
    end

    tests('#delete webhook').raises(Fog::Rackspace::AutoScale::NotFound) do
      service.delete_webhook(@group_id, @policy_id, 123)
    end
  end

end