Shindo.tests("Fog::Compute[:aws] | subnets", ['aws']) do
  @vpc=Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.10.0/28')
  collection_tests(Fog::Compute[:aws].subnets, { :vpc_id => @vpc.id, :cidr_block => '10.0.10.0/28'}, true)
  @vpc.destroy
end

