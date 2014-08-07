require 'securerandom'
Shindo.tests("Fog::Compute[:google] | target instance model", ['google']) do
  random_string = SecureRandom.hex
  @zone = 'us-central1-a'
  instance = create_test_server(Fog::Compute[:google], @zone)  
  model_tests(Fog::Compute[:google].target_instances, {:name => "fog-test-target-instance-#{random_string}", :instance => instance.self_link, :zone => @zone})
end
