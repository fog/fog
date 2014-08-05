Shindo.tests("Fog::Compute[:google] | disks", ['google']) do

  collection_tests(Fog::Compute[:google].disks, {:name => 'fog-disks-collections-tests',
                                                 :zone => 'us-central1-a',
                                                 :size_gb => 10}) do |instance|
  	instance.wait_for { ready? }
  end

end
