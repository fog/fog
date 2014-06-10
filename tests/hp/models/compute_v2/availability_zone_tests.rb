Shindo.tests("Fog::Compute::HPV2 | availability zone model", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @zones = service.availability_zones

  tests('#available?').succeeds do
    @zones.first.respond_to?('available?')
  end

end
