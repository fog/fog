Shindo.tests("Fog::Compute[:google] | disks", ['google']) do

  collection_tests(Fog::Compute[:google].disks, {:name => 'fogdiskname', :zone => 'us-central1-a'})

end
