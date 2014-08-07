Shindo.tests('Fog::Compute[:google] | url map requests', ['google']) do

  @google = Fog::Compute[:google]

  @insert_url_map_format = {
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

  @get_url_map_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'hostRules' => Array,
      'pathMatchers' => Array,
      'tests' => Array,
      'defaultService' => String,
  }

  @delete_url_map_format = {
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

  @list_url_maps_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => Array
  }

  tests('success') do

    url_map_name = 'test-url-map'

    # These will all fail if errors happen on insert
    tests("#insert_url_map").formats(@insert_url_map_format) do
      backend_service = create_test_backend_service(Fog::Compute[:google])
      options = { 'defaultService' => backend_service.self_link }
      response = @google.insert_url_map(url_map_name, options).body
      wait_operation(@google, response)
      response
    end

    tests("#get_url_map").formats(@get_url_map_format) do
      @google.get_url_map(url_map_name).body
    end

    tests("#list_url_maps").formats(@list_url_maps_format) do
      @google.list_url_maps.body
    end

    tests("#delete_url_map").formats(@delete_url_map_format) do
      @google.delete_url_map(url_map_name).body
    end

  end

end
