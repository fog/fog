Shindo.tests("Fog::Compute[:hp] | address", ['hp']) do

  model_tests(Fog::Compute[:hp].addresses, {}, true) do

    @server = Fog::Compute[:hp].servers.create(:name => "fogservertests", :flavor_id => 100, :image_id => 1242)
    @server.wait_for { ready? }

    tests('#server=').succeeds do
      @instance.server = @server
    end

    @server.destroy

  end

end
