Shindo.tests("Fog::Compute[:aws] | network_acls", ['aws']) do
  @vpc = Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.10.0/24')

  collection_tests(Fog::Compute[:aws].network_acls, { :vpc_id => @vpc.id }, true)
  
  @vpc.destroy
end
