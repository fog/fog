require 'securerandom'
Shindo.tests("Fog::Compute[:google] | global forwarding rule model", ['google']) do
  random_string = SecureRandom.hex
  proxy = create_test_target_http_proxy(Fog::Compute[:google])
  model_tests(Fog::Compute[:google].global_forwarding_rules, {:name => "fog-test-global-forwarding-rule-#{random_string}", :target => proxy.self_link})

end
