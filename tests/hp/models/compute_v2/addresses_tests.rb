Shindo.tests("Fog::Compute::HPV2 | addresses collection", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  collection_tests(service.addresses, {}, true)

end
