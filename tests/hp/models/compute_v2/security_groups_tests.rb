Shindo.tests("Fog::Compute::HPV2| security_groups", ['hp']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  collection_tests(service.security_groups, {:name => 'foggroupname', :description => 'foggroupdescription'}, true)

end
