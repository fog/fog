require 'securerandom'
Shindo.tests("Fog::Compute[:google] | HTTP health check model", ['google']) do
  random_string = SecureRandom.hex
  model_tests(Fog::Compute[:google].http_health_checks, {:name => "fog-test-http-health-check-#{random_string}"})
end
