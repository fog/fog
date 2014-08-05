Shindo.tests("Fog::Compute::HPV2 | availability zones collection", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  tests('#all').succeeds do
    @zones = service.availability_zones
  end

  tests('#get').succeeds do
    @zones.get('az1').name == 'az1'
  end

end
