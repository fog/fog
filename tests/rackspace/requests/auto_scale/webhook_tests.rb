Shindo.tests('Fog::Rackspace::AutoScale | webhook_tests', ['rackspace', 'rackspace_autoscale']) do
  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  begin
    @group_id = service.create_group(LAUNCH_CONFIG_OPTIONS, GROUP_CONFIG_OPTIONS, POLICIES_OPTIONS).body['group']['id']
    @policy_id = service.create_policy(@group_id, POLICY_OPTIONS).body['policies'][0]['id']

    tests('success') do
      tests('#create_webhook').formats(201) do
        response = service.create_webhook(@group_id, @policy_id, WEBHOOK_OPTIONS)
        @webhook_id = response.body['webhooks'][0]['id']
        response.data[:status]
      end

      tests('#list_webhooks').formats(LIST_WEBHOOKS_FORMAT, false) do
        response = service.list_webhooks(@group_id, @policy_id).body["webhooks"]
      end

      tests('#get_webhook').formats(WEBHOOK_FORMAT) do
        response = service.get_webhook(@group_id, @policy_id, @webhook_id)
        response.body['webhook']
      end

      tests('#update_webhook').formats(204) do
        response = service.update_webhook(@group_id, @policy_id, @webhook_id, {'name' => 'new', 'metadata' => {}} )
        response.data[:status]
      end

      tests('#delete_webhook').formats(204) do
        response = service.delete_webhook(@group_id, @policy_id, @webhook_id)
        response.data[:status]
      end
    end
  ensure
    service.delete_policy @group_id, @policy_id
    service.delete_group @group_id
  end

  tests('failure') do
    tests('#create_webhook').raises(Fog::Rackspace::AutoScale::BadRequest) do
      service.create_webhook(@group_id, @policy_id, {})
    end

    tests('#get_webhook').raises(Fog::Rackspace::AutoScale::NotFound) do
      service.get_webhook(@group_id, @policy_id, 123)
    end

    tests('#update_webhook').raises(Fog::Rackspace::AutoScale::BadRequest) do
      service.update_webhook(@group_id, @policy_id, @webhook_id, {})
    end

    tests('#delete_webhook').raises(Fog::Rackspace::AutoScale::NotFound) do
      service.delete_webhook(@group_id, @policy_id, 123)
    end
  end

end
