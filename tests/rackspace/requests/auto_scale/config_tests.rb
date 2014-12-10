Shindo.tests('Fog::Rackspace::AutoScale | config_tests', ['rackspace', 'rackspace_autoscale']) do

  pending if Fog.mocking?
  service = Fog::Rackspace::AutoScale.new :rackspace_region => :ord

  begin
    @group = service.create_group(LAUNCH_CONFIG_OPTIONS, GROUP_CONFIG_OPTIONS, POLICIES_OPTIONS).body['group']
    @group_id = @group['id']

    tests('success') do
      tests('#get_group_config').formats({"groupConfiguration" => GROUP_CONFIG_FORMAT}) do
        service.get_group_config(@group_id).body
      end
      tests('#update_group_config').returns(204) do
        data = service.update_group_config(@group_id, {
          'maxEntities' => 0,
          'minEntities' => 0,
          'metadata' => {},
          'name' => 'foo',
          'cooldown' => 20})
        data.status
      end

      tests('#get_launch_config').formats(LAUNCH_CONFIG_FORMAT) do
        service.get_launch_config(@group_id).body["launchConfiguration"]
      end
      tests('#update_launch_config').returns(204) do
        data = service.update_launch_config(@group_id, {
		"args" => {
              "loadBalancers" => [
                {
                  "port" => 8000,
                  "loadBalancerId" => 9099
                }
              ],
              "server" => {
                "name" => "autoscale_server",
                "imageRef" => "0d589460-f177-4b0f-81c1-8ab8903ac7d8",
                "flavorRef" => "2",
                "OS-DCF =>diskConfig" => "AUTO",
                "metadata" => {
                  "build_config" => "core",
                  "meta_key_1" => "meta_value_1",
                  "meta_key_2" => "meta_value_2"
                },
                "networks" => [
                  {
                    "uuid" => "11111111-1111-1111-1111-111111111111"
                  },
                  {
                    "uuid" => "00000000-0000-0000-0000-000000000000"
                  }
                ],
                "personality" => [
                  {
                    "path" => "/root/.csivh",
                    "contents" => "VGhpcyBpcyBhIHRlc3QgZmlsZS4="
                  }
                ]
              }
            },
            "type" => "launch_server"
            })
        data.status
      end
    end
  ensure
    service.delete_group(@group_id)
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
