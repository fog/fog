Shindo.tests("Fog::Compute[:google] | disks", ['google']) do

  disk_name = 'fog-test-disk-' + Time.now.to_i.to_s

  collection_tests(Fog::Compute[:google].disks, {:name => disk_name, :zone_name => 'us-central1-a', :size_gb => 10})

end
