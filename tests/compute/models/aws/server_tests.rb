Shindo.tests("AWS::Compute | monitor", ['aws']) do

  @instance = AWS[:compute].servers.new

  [:addresses, :flavor, :key_pair, :key_pair=, :volumes].each do |association|
    responds_to(association)
  end


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

    [:id, :availability_zone, :flavor_id, :kernel_id, :image_id, :state].each do |attr|
      test("instance##{attr} should not contain whitespace") do
        nil == @instance.send(attr).match(/\s/)
      end
    end

    test('#monitor = true') do
      @instance.monitor = true
      @instance.monitoring == true
    end

    test('#monitor = false') do
      @instance.monitor = false
      @instance.monitoring == false
    end

  end

  @instance.destroy
end
