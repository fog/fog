Shindo.tests('Fog::Rackspace::Database | user_tests', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Databases.new
  instance_name = 'fog' + Time.now.to_i.to_s
  instance_id = service.create_instance(instance_name, 1, 1).body['instance']['id']

  wait_for_request("Waiting for database to be created") do
    service.get_instance(instance_id).body["instance"]["status"] == 'ACTIVE'
  end

  tests('success') do
    user_name = 'fog' + Time.now.to_i.to_s
    password = 'password1'

    tests("#create_user(#{instance_id}, #{user_name}, #{password})").returns(202) do
      service.create_user(instance_id, user_name, password).status
    end

    tests("#list_users{#{instance_id})").formats(LIST_USERS_FORMAT) do
      service.list_users(instance_id).body
    end

    tests("#delete_user(#{instance_id}, #{user_name})").returns(202)  do
      service.delete_user(instance_id, user_name).status
    end
  end

  tests('failure') do
    tests("#create_user(#{instance_id}, '', '') => Invalid Create Critera").raises(Fog::Rackspace::Databases::BadRequest) do
      service.create_user(instance_id, '', '')
    end
  end

  service.delete_instance(instance_id)
end
