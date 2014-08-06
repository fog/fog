Shindo.tests("Fog::Compute[:google] | target HTTP proxies model", ['google']) do
  url_map = create_test_url_map(Fog::Compute[:google])  
  collection_tests(Fog::Compute[:google].target_http_proxies, {:name => 'fog-target-http-proxies-test', :urlMap => url_map.self_link})

end
