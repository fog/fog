require 'securerandom'
Shindo.tests("Fog::Compute[:google] | HTTP health checks model", ['google']) do
  random_string = SecureRandom.hex
  collection_tests(Fog::Compute[:google].http_health_checks, {:name => "fog-test-http-health-check-#{random_string}"})
end
