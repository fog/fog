require 'securerandom'
Shindo.tests("Fog::Compute[:google] | backend_services model", ['google']) do
  random_string = SecureRandom.hex
  @health_check = create_test_http_health_check(Fog::Compute[:google])
  collection_tests(Fog::Compute[:google].backend_services, {:name => "fog-backend-services-test-#{random_string}", 
      :health_checks => [@health_check]})

end
