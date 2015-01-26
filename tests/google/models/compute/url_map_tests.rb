require 'securerandom'
Shindo.tests("Fog::Compute[:google] | url map model", ['google']) do
  random_string = SecureRandom.hex
  backend_service = create_test_backend_service(Fog::Compute[:google])  
  model_tests(Fog::Compute[:google].url_maps, {:name => "fog-test-url-map-#{random_string}", :defaultService => backend_service.self_link})
end
