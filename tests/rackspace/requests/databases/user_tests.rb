Shindo.tests('Fog::Rackspace::Database | user_tests', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Databases.new
  instance_name = 'fog' + Time.now.to_i.to_s
  instance_id = service.create_instance(instance_name, 1, 1).body['instance']['id']

  until service.get_instance(instance_id).body["instance"]["status"] == 'ACTIVE'
    sleep 10
  end

  tests('success') do
    user_name = 'fog' + Time.now.to_i.to_s
    password = 'password1'

    tests("#create_user(#{instance_id}, #{user_name}, #{password})").succeeds do
      service.create_user(instance_id, user_name, password).body
    end

    tests("#list_users{#{instance_id})").formats(LIST_USERS_FORMAT) do
      service.list_users(instance_id).body
    end

    tests("#delete_user(#{instance_id}, #{user_name})").succeeds do
      service.delete_user(instance_id, user_name)
    end
  end

  tests('failure') do
    tests("#create_user(#{instance_id}, '', '') => Invalid Create Critera").raises(Fog::Rackspace::Databases::BadRequest) do
      service.create_user(instance_id, '', '')
    end
  end

  service.delete_instance(instance_id)
end
