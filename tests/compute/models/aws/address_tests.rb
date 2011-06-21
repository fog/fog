Shindo.tests("Fog::Compute[:aws] | address", ['aws']) do

  model_tests(Fog::Compute[:aws].addresses, {}, true) do

    @server = Fog::Compute[:aws].servers.create
    @server.wait_for { ready? }

    tests('#server=').succeeds do
      @instance.server = @server
    end

    @server.destroy

  end

end
