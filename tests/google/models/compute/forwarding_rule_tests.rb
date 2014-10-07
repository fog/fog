require 'securerandom'
Shindo.tests("Fog::Compute[:google] | forwarding rule model", ['google']) do
  random_string = SecureRandom.hex
  region = 'us-central1'
  target_pool = create_test_target_pool(Fog::Compute[:google], region)
  model_tests(Fog::Compute[:google].forwarding_rules, {:name => "fog-test-forwarding-rules-#{random_string}", :region => region, :target => target_pool.self_link})

end
