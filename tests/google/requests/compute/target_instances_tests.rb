Shindo.tests('Fog::Compute[:google] | target instance requests', ['google']) do

  @google = Fog::Compute[:google]

  @insert_target_instance_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'zone' => String,
      'insertTime' => String,
      'startTime' => String,
      'operationType' => String
  }

  @get_target_instance_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'zone' => String,
      'natPolicy' => String,
      'instance' => String,
      'description' => String
  }

  @delete_target_instance_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'targetId' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'insertTime' => String,
      'zone' => String,
      'startTime' => String,
      'operationType' => String
  }

  @list_target_instances_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => Array
  }

  tests('success') do

    target_instance_name = 'test-target_instance'
    @zone = 'us-central1-a'

    # These will all fail if errors happen on insert
    tests("#insert_target_instance").formats(@insert_target_instance_format) do
      instance = create_test_server(Fog::Compute[:google], @zone)
      options = { 'instance' => instance.self_link, 'zone' => @zone }
      response = @google.insert_target_instance(target_instance_name, @zone, options).body
      wait_operation(@google, response)
      response
    end

    tests("#get_target_instance").formats(@get_target_instance_format) do
      @google.get_target_instance(target_instance_name, @zone).body
    end

    tests("#list_target_instances").formats(@list_target_instances_format) do
      @google.list_target_instances(@zone).body
    end

    tests("#delete_target_instance").formats(@delete_target_instance_format) do
      @google.delete_target_instance(target_instance_name, @zone).body
    end

  end

end
