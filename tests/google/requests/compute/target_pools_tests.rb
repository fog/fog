Shindo.tests('Fog::Compute[:google] | target pools requests', ['google']) do

  @google = Fog::Compute[:google]

  @insert_target_pool_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'region' => String,
      'insertTime' => String,
      'startTime' => String,
      'operationType' => String
  }

  @get_target_pool_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'region' => String,
      'healthChecks' => Array,
      'instances' => Array,
  }

  @delete_target_pool_format = {
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
      'region' => String,
      'startTime' => String,
      'operationType' => String
  }

  @list_target_pools_format = {
      'kind' => String,
      'id' => String,
      'items' => Array,
      'selfLink' => String
  }

  tests('success') do

    target_pool_name = 'test-target_pool'
    region_name = 'us-central1'
    # These will all fail if errors happen on insert
    tests("#insert_target_pool").formats(@insert_target_pool_format) do
      instance = create_test_server(Fog::Compute[:google], 'us-central1-a')
      health_check = create_test_http_health_check(Fog::Compute[:google])
      options = { 'instances' => [instance.self_link], 'healthChecks' => [health_check.self_link] }
      response = @google.insert_target_pool(target_pool_name, region_name, options).body
      wait_operation(@google, response)
      response
    end

    tests("#get_target_pool").formats(@get_target_pool_format) do
      @google.get_target_pool(target_pool_name, region_name).body
    end

    tests("#list_target_pools").formats(@list_target_pools_format) do
      @google.list_target_pools(region_name).body
    end

    tests("#delete_target_pool").formats(@delete_target_pool_format) do
      @google.delete_target_pool(target_pool_name, region_name).body
    end

  end

end
