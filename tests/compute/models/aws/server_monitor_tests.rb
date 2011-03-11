Shindo.tests("AWS::Compute::Server | monitor", ['aws']) do

  config = compute_providers[AWS]

  if !Fog.mocking? || config[:mocked]
    @instance = AWS[:compute].servers.new(config[:server_attributes])
  end

  tests('new instance') do

    test('monitor') do
      @instance.monitoring = true
      @instance.attributes[:monitoring] == true
    end

    test('unmonitor') do
      @instance.monitoring = false
      @instance.attributes[:monitoring] == false
    end

  end

  tests('existing instance') do

    @instance.save

    test('monitor') do
      #what I'd really like to test is if connection.monitor_instances is being called
      #this is a safeguard
      @instance.identity != nil
      @instance.monitoring = true
      @instance.attributes[:monitoring] == true
    end

    test('unmonitor') do
      #what I'd really like to test is if connection.monitor_instances is being called
      #this is a safeguard
      @instance.identity != nil
      @instance.monitoring = false
      @instance.attributes[:monitoring] == false
    end

  end

end