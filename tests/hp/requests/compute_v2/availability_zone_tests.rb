Shindo.tests("Fog::Compute::HPV2 | availability_zone requests", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @zone_format = {
    'zoneName'    => String,
    'zoneState'   => Hash,
    'hosts'       => nil
  }

  tests('success') do

    tests('#list_availability_zones').formats([@zone_format]) do
      service.list_availability_zones.body['availabilityZoneInfo']
    end

  end

end
