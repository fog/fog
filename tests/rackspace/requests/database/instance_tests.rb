Shindo.tests('Fog::Rackspace::Database | instance_tests', ['rackspace']) do

  pending if Fog.mocking?

  @service = Fog::Rackspace::Databases.new

  LINK_FORMAT = [{'href' => String, 'rel' => String}]

  DATABASE_INSTANCE_FORMAT = {
      'created' => String,
      'flavor' => {
        'id' => String,
        'links' => LINK_FORMAT
      },
      'hostname' => String,
      'id' => String,
      'links' => LINK_FORMAT,
      'name' => String,
      'status' => String,
      'updated' => String,
      'volume' => { 'size' => Integer},
    }
  DATABASE_CREATE_INSTANCE_FORMAT = {
    'instance' => DATABASE_INSTANCE_FORMAT
  }
  DATABASE_GET_INSTANCE_FORMAT = {
    'instance' => DATABASE_INSTANCE_FORMAT.merge({'rootEnabled' => Fog::Boolean, 'volume' => {'size' => Integer, 'used' => Float}})
  }
  DATABASE_LIST_INSTANCES_FORMAT = {
    'instances' => [
      DATABASE_INSTANCE_FORMAT
    ]
  }


  tests('success') do

    @db_id = nil
    @db_name = 'fog' + Time.now.to_i.to_s

    tests("#create_instance(#{@db_name}, 1, 1)").formats(DATABASE_CREATE_INSTANCE_FORMAT) do
      data = @service.create_instance(@db_name, 1, 1).body
      @db_id = data['instance']['id']
      data
    end

    until @service.get_instance(@db_id).body["instance"]["status"] == 'ACTIVE'
      sleep 10
    end

    tests("#list_instances_details").formats(DATABASE_LIST_INSTANCES_FORMAT) do
      data = @service.list_instances_details.body
      puts data.inspect
      data
    end

    tests("#get_instance(#{@db_id}").formats(DATABASE_GET_INSTANCE_FORMAT) do
      @service.get_instance(@db_id).body
    end

    tests("#delete_instance(#{@db_id})").succeeds do 
      @service.delete_instance(@db_id)
    end

  end

  tests('failure') do
    tests("#create_instance('', 0, 0) => Invalid Create Critera").raises(Fog::Rackspace::Databases::BadRequest) do
      @service.create_instance('', 0, 0)
    end

    tests("#get_instance('') => Does not exist").raises(Fog::Rackspace::Databases::NotFound) do
      @service.get_instance('')
    end
    
  end
end
