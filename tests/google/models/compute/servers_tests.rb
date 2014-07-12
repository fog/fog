require 'securerandom'

Shindo.tests("Fog::Compute[:google] | servers", ['google']) do

  @zone = 'us-central1-a'
  @disk = create_test_disk(Fog::Compute[:google], @zone)
  random_string = SecureRandom.hex

  collection_tests(Fog::Compute[:google].servers, {:name => "fog-test-server-#{random_string}",
                                                   :zone_name => @zone,
                                                   :machine_type => 'n1-standard-1',
                                                   :disks => [@disk]})

end
