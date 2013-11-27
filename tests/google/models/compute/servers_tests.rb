Shindo.tests("Fog::Compute[:google] | servers", ['google']) do

  collection_tests(Fog::Compute[:google].servers, {:name => 'fogservername', :zone_name => 'us-central1-a', :machine_type => 'n1-standard-1'})

end
