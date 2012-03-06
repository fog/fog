Shindo.tests("Fog::Compute[:aws] | vpcs", ['aws']) do

  collection_tests(Fog::Compute[:aws].vpcs, {:cidr_block => '10.0.10.0/28'}, true)

end

