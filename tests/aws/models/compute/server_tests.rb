Shindo.tests("Fog::Compute[:aws] | monitor", ['aws']) do

  @instance = Fog::Compute[:aws].servers.new

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

  tests('tags') do
    @instance = Fog::Compute[:aws].servers.create(:tags => {'key' => 'value'})

    @instance.wait_for { ready? }

    tests('@instance.reload.tags').returns({'key' => 'value'}) do
      @instance.reload.tags
    end

    unless Fog.mocking?
      Fog::Compute[:aws].tags.all('resource-id' => @instance.identity).each {|tag| tag.destroy}
    end

    @instance.destroy
  end

end
