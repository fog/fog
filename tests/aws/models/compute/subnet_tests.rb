Shindo.tests("Fog::Compute[:aws] | subnet", ['aws']) do
  @vpc = Fog::Compute[:aws].vpcs.create('cidr_block' => '10.0.10.0/24')
  @availability_zones = Fog::Compute[:aws].describe_availability_zones('state' => 'available').body['availabilityZoneInfo'].collect{ |az| az['zoneName'] }

  # Try making a subnet in each AZ.
  @availability_zones.each do |az|
    model_tests(Fog::Compute[:aws].subnets, {:vpc_id => @vpc.id, :cidr_block => '10.0.10.0/28', :availability_zone => az}, true) do
      tests("availability_zone").returns(az) do
        @instance.availability_zone
      end
    end
  end
  @vpc.destroy
end
