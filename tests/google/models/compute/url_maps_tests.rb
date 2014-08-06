Shindo.tests("Fog::Compute[:google] | url maps model", ['google']) do
  backend_service = create_test_backend_service(Fog::Compute[:google])  
  collection_tests(Fog::Compute[:google].url_maps, {:name => 'fog-url-maps-test', :defaultService => backend_service.self_link})

end
