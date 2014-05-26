Shindo.tests("Fog::Compute::HPV2 | key_pair model", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  model_tests(service.key_pairs, {:name => 'fogkeyname'}, true)

  after do
    @keypair.destroy
  end

  tests('new keypair') do
    @keypair = service.key_pairs.create(:name => 'fogtestkey')

    test('writable?') do
      @keypair.writable? == true
    end
  end

  tests('existing keypair') do
    service.key_pairs.create(:name => 'fogtestkey')
    @keypair = service.key_pairs.get('fogtestkey')

    test('writable?') do
      @keypair.writable? == false
    end
  end

end
