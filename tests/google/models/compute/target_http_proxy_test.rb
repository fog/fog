require 'securerandom'
Shindo.tests("Fog::Compute[:google] | target HTTP proxy model", ['google']) do
  random_string = SecureRandom.hex
  url_map = create_test_url_map(Fog::Compute[:google])
  model_tests(Fog::Compute[:google].target_http_proxies, {:name => "fog-test-target-http-proxy-#{random_string}", :urlMap => url_map.self_link})
end
