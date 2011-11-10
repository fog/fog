Shindo.tests("Fog::Compute[:aws] | volume", ['aws']) do

  @server = Fog::Compute[:aws].servers.create
  @server.wait_for { ready? }

  model_tests(Fog::Compute[:aws].volumes, {:availability_zone => @server.availability_zone, :size => 1, :device => '/dev/sdz1'}, true) do

    @instance.wait_for { ready? }

    tests('#server = @server').succeeds do
      @instance.server = @server
    end

    @instance.wait_for { state == 'in-use' }

    tests('#server').succeeds do
      @instance.server
    end

    tests('#server = nil').succeeds do
      @instance.server = nil
    end

    @instance.wait_for { ready? }

    @instance.server = @server
    @instance.wait_for { state == 'in-use' }

    tests('#force_detach').succeeds do
      @instance.force_detach
    end

    @instance.wait_for { ready? }

  end

  @server.destroy

end
