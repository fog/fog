Shindo.tests("Fog::Compute[:google] | disks", ['google']) do

  collection_tests(Fog::Compute[:google].disks, {:name => 'fogdiskname', :zone_name => 'us-central1-a'})

end
