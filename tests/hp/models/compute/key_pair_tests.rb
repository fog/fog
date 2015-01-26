Shindo.tests("Fog::Compute[:hp] | key_pair", ['hp']) do

  model_tests(Fog::Compute[:hp].key_pairs, {:name => 'fogkeyname'}, true)

  after do
    @keypair.destroy
  end

  tests("new keypair") do
    @keypair = Fog::Compute[:hp].key_pairs.create(:name => 'testkey')

    test ("writable?") do
      @keypair.writable? == true
    end
  end

  tests("existing keypair") do
    Fog::Compute[:hp].key_pairs.create(:name => 'testkey')
    @keypair = Fog::Compute[:hp].key_pairs.get('testkey')

    test("writable?") do
      @keypair.writable? == false
    end
  end

end
