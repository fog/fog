Shindo.tests('Fog::Compute[:google] | target HTTP proxy requests', ['google']) do

  @google = Fog::Compute[:google]

  @insert_target_http_proxy_format = {
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

  @get_target_http_proxy_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'urlMap' => String,
  }

  @delete_target_http_proxy_format = {
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

  @list_target_http_proxies_format = {
      'kind' => String,
      'selfLink' => String,
      'id' => String,
      'items' => Array
  }

  tests('success') do

    target_http_proxy_name = 'test-target-http-proxy'

    # These will all fail if errors happen on insert
    tests("#insert_target_http_proxy").formats(@insert_target_http_proxy_format) do
      url_map = create_test_url_map(Fog::Compute[:google])
      options = { 'urlMap' => url_map.self_link }
      response = @google.insert_target_http_proxy(target_http_proxy_name, options).body
      wait_operation(@google, response)
      response
    end

    tests("#get_target_http_proxy").formats(@get_target_http_proxy_format) do
      @google.get_target_http_proxy(target_http_proxy_name).body
    end

    tests("#list_target_http_proxies").formats(@list_target_http_proxies_format) do
      @google.list_target_http_proxies.body
    end

    tests("#delete_target_http_proxy").formats(@delete_target_http_proxy_format) do
      @google.delete_target_http_proxy(target_http_proxy_name).body
    end

  end

end
