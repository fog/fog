Shindo.tests("Fog::Compute[:google] | servers", ['google']) do

  @zone = 'us-central1-a'
  @disk = create_test_disk(Fog::Compute[:google], @zone)
  server_name = 'fog-test-server-' + Time.now.to_i.to_s

  collection_tests(Fog::Compute[:google].servers, {:name => server_name, :zone_name => @zone, :machine_type => 'n1-standard-1', :disks => [@disk]})

end
