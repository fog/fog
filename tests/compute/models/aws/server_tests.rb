Shindo.tests("AWS::Compute | monitor", ['aws']) do

  [:addresses, :flavor, :key_pair, :key_pair=, :volume].each do |association|
    responds_to(association)
  end

  @instance = AWS[:compute].servers.new(:image_id => 'ami-1a837773')

  tests('new instance') do

    test('#monitor = true') do
      @instance.monitor = true
      @instance.attributes[:monitoring] == true
    end

    test('#monitor = false') do
      @instance.monitor = false
      @instance.attributes[:monitoring] == false
    end

  end

  tests('existing instance') do

    @instance.save

    test('#monitor = true') do
      @instance.monitor = true
      @instance.monitoring == true
    end

    test('#monitor = false') do
      @instance.monitor = false
      @instance.monitoring == false
    end

  end

end
