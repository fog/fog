require 'securerandom'
Shindo.tests("Fog::Compute[:google] | target pools model", ['google']) do
  random_string = SecureRandom.hex
  region = 'us-central1'
  instance = create_test_server(Fog::Compute[:google], 'us-central1-a')
  health_check = create_test_http_health_check(Fog::Compute[:google])
  collection_tests(
    Fog::Compute[:google].target_pools,
    {:name => "fog-test-target-pool-#{random_string}", :region => region, :instances => [instance.self_link], :healthChecks => [health_check.self_link]}
  )
end
