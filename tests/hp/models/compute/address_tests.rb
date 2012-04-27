Shindo.tests("Fog::Compute[:hp] | address", ['hp']) do

  @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

  model_tests(Fog::Compute[:hp].addresses, {}, true) do

    @server = Fog::Compute[:hp].servers.create(:name => "fogservertests", :flavor_id => 100, :image_id => @base_image_id)
    @server.wait_for { ready? }

    tests('#server=').succeeds do
      @instance.server = @server
    end

    @server.destroy

  end

end
