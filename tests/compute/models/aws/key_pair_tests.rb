Shindo.tests("AWS::Compute | key_pair", ['aws']) do

  model_tests(AWS[:compute].key_pairs, {:name => 'fogkeyname'}, true)

  after do
    @keypair.destroy
  end

  tests("new keypair") do
    @keypair = AWS[:compute].key_pairs.create(:name => 'testkey')

    test ("writable?") do
      @keypair.writable? == true
    end
  end

  tests("existing keypair") do
    AWS[:compute].key_pairs.create(:name => 'testkey')
    @keypair = AWS[:compute].key_pairs.get('testkey')

    test("writable?") do
      @keypair.writable? == false
    end
  end


end
