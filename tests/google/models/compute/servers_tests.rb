Shindo.tests("Fog::Compute[:google] | servers", ['google']) do

  @zone = 'us-central1-a'
  @disk = create_test_disk(Fog::Compute[:google], @zone)

  collection_tests(Fog::Compute[:google].servers, {:name => 'fogservername', :zone_name => @zone, :machine_type => 'n1-standard-1', :disks => [@disk]})

end
