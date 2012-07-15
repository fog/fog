Shindo.tests('Fog::Rackspace::Database | database_tests', ['rackspace']) do

  pending if Fog.mocking?

  service = Fog::Rackspace::Databases.new
  instance_name = 'fog' + Time.now.to_i.to_s
  instance_id = service.create_instance(instance_name, 1, 1).body['instance']['id']

  until service.get_instance(instance_id).body["instance"]["status"] == 'ACTIVE'
    sleep 10
  end

  tests('success') do
    database_name = 'fogdb' + Time.now.to_i.to_s

    tests("#create_database(#{instance_id}, #{database_name})").succeeds do
      service.create_database(instance_id, database_name).body
    end

    tests("#list_databases{#{instance_id})").formats(LIST_DATABASES_FORMAT) do
      service.list_databases(instance_id).body
    end

    tests("#delete_database(#{instance_id}, #{database_name})").succeeds do
      service.delete_database(instance_id, database_name)
    end
  end

  tests('failure') do
    tests("#create_database(#{instance_id}, '') => Invalid Create Critera").raises(Fog::Rackspace::Databases::BadRequest) do
      service.create_database(instance_id, '')
    end
  end

  service.delete_instance(instance_id)
end
