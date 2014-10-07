require 'securerandom'
Shindo.tests("Fog::Compute[:google] | target instances model", ['google']) do
  @zone= 'us-central1-a'
  random_string = SecureRandom.hex
  instance = create_test_server(Fog::Compute[:google], @zone)
  collection_tests(Fog::Compute[:google].target_instances, {:name => "fog-test-target-instances-#{random_string}", :instance => instance.self_link, :zone => @zone})
end
