Shindo.tests("Fog::Compute[:google] | disks", ['google']) do

  collection_tests(Fog::Compute[:google].disks, {:name => 'fogdiskname', :zone_name => 'us-central1-a', :size_gb => 10})

end
