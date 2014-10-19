require 'securerandom'
Shindo.tests("Fog::Compute[:google] | url maps model", ['google']) do
  backend_service = create_test_backend_service(Fog::Compute[:google])  
  random_string = SecureRandom.hex
  collection_tests(Fog::Compute[:google].url_maps, {:name => "fog-url-maps-test-#{random_string}", :defaultService => backend_service.self_link})

end
