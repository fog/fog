Shindo.tests("Fog::Compute::HPV2 | key pairs collection", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  collection_tests(service.key_pairs, {:name => 'fogkeyname'}, true)

end
