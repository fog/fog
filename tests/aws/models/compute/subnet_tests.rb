Shindo.tests("Fog::Compute[:aws] | subnet", ['aws']) do
  @vpc = Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.10.0/24')
  @availability_zones = Fog::Compute[:aws].describe_availability_zones('state' => 'available').body['availabilityZoneInfo'].collect{ |az| az['zoneName'] }
  model_tests(Fog::Compute[:aws].subnets, {:vpc_id => @vpc.id, :cidr_block => '10.0.10.0/28', :availability_zone => @availability_zones.last}, true) do
    test("availability_zone") do
      @instance.availability_zone == @availability_zones.last
    end
  end
  @vpc.destroy
end
