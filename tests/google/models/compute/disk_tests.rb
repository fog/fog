Shindo.tests("Fog::Compute[:google] | disk model", ['google']) do

  model_tests(Fog::Compute[:google].disks, {:name => 'fogdiskname', :zone => 'us-central1-a'})

end
