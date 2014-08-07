Shindo.tests('Fog::Compute[:google] | backend services requests', ['google']) do

  @google = Fog::Compute[:google]

  @insert_backend_service_format = {
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

  @get_backend_service_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'backends' => Array,
      'healthChecks' => Array,
      'port' => Integer,
      'protocol' => String,
  }

  @delete_backend_service_format = {
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

  @list_backend_services_format = {
      'kind' => String,
      'selfLink' => String,
      'id' => String,
      'items' => Array
  }

  tests('success') do

    backend_service_name = 'test-backend-service'
    zone_name = 'us-central1-a'

    # These will all fail if errors happen on insert
    tests("#insert_backend_service").formats(@insert_backend_service_format) do
      health_check = create_test_http_health_check(Fog::Compute[:google])
      options = { 'health_check' => health_check }
      response = @google.insert_backend_service(backend_service_name, options).body
      wait_operation(@google, response)
      response
    end

    tests("#list_backend_services").formats(@list_backend_services_format) do
      @google.list_backend_services.body
    end

    tests("#get_backend_service").formats(@get_backend_service_format) do
      @google.get_backend_service(backend_service_name).body
    end

    tests("#delete_backend_service").formats(@delete_backend_service_format) do
      @google.delete_backend_service(backend_service_name).body
    end

  end

end
