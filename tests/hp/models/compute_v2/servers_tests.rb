Shindo.tests("Fog::Compute::HPV2 | servers collection", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @base_image_id = ENV['BASE_IMAGE_ID'] || '7f60b54c-cd15-433f-8bed-00acbcd25a17'

  collection_tests(service.servers, {:name => 'fogservercolltest', :flavor_id => 100, :image_id => @base_image_id}, true)

end
