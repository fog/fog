Shindo.tests("Fog::Compute[:google] | target instances model", ['google']) do
  @zone= 'us-central1-a'
  instance = create_test_server(Fog::Compute[:google], @zone)
  collection_tests(Fog::Compute[:google].target_instances, {:name => 'fog-test-target-instances', :instance => instance.self_link, :zone => @zone})
end
