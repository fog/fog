Shindo.tests('Fog::Rackspace::Database | instance_tests', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Databases.new

  tests('success') do

    instance_id = nil
    instance_name = 'fog' + Time.now.to_i.to_s

    tests("#list_instances").formats(LIST_INSTANCES_FORMAT) do
      service.list_instances.body
    end

    tests("#create_instance(#{instance_name}, 1, 1)").formats(CREATE_INSTANCE_FORMAT) do
      data = service.create_instance(instance_name, 1, 1).body
      instance_id = data['instance']['id']
      data
    end

    until service.get_instance(instance_id).body["instance"]["status"] == 'ACTIVE'
      sleep 10
    end

    tests("#get_instance(#{instance_id})").formats(GET_INSTANCE_FORMAT) do
      service.get_instance(instance_id).body
    end

    tests("#check_root_user(#{instance_id})").formats(CHECK_ROOT_USER_FORMAT) do
      service.check_root_user(instance_id).body
    end

    tests("#enable_root_user(#{instance_id})").formats(ENABLE_ROOT_USER_FORMAT) do
      service.enable_root_user(instance_id).body
    end

    tests("#restart_instance(#{instance_id})").succeeds do
      service.restart_instance(instance_id)
    end

    until service.get_instance(instance_id).body["instance"]["status"] == 'ACTIVE'
      sleep 10
    end

    tests("#resize_instance(#{instance_id}, 2)").succeeds do
      service.resize_instance(instance_id, 2)
    end

    until service.get_instance(instance_id).body["instance"]["status"] == 'ACTIVE'
      sleep 10
    end

    tests("#resize_instance_volume(#{instance_id}, 2)").succeeds do
      service.resize_instance_volume(instance_id, 2)
    end

    until service.get_instance(instance_id).body["instance"]["status"] == 'ACTIVE'
      sleep 10
    end

    tests("#delete_instance(#{instance_id})").succeeds do
      service.delete_instance(instance_id)
    end
  end

  tests('failure') do
    tests("#create_instance('', 0, 0) => Invalid Create Critera").raises(Fog::Rackspace::Databases::BadRequest) do
      service.create_instance('', 0, 0)
    end

    tests("#get_instance('') => Does not exist").raises(Fog::Rackspace::Databases::NotFound) do
      service.get_instance('')
    end

  end
end
