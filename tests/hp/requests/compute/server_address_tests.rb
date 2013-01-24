Shindo.tests("Fog::Compute[:hp] | address requests", ['hp']) do

  @base_image_id = ENV["BASE_IMAGE_ID"] || 1242

  tests('success') do
    @server = Fog::Compute[:hp].servers.create(:name => 'fogaddresstests', :flavor_id => 100, :image_id => @base_image_id)
    @server.wait_for { ready? }
    @address = Fog::Compute[:hp].addresses.create
    @address.server = @server

    # the network name is currently named 'private'
    tests("#list_server_addresses(#{@server.id})").formats({'addresses' => {"private" => [{'version' => Integer, 'addr' => String}]}}) do
      Fog::Compute[:hp].list_server_addresses(@server.id).body
    end

    tests("#list_server_private_addresses(#{@server.id}, 'private')").formats({'private' => [{'version' => Integer, 'addr' => String}]}) do
      Fog::Compute[:hp].list_server_private_addresses(@server.id, 'private').body
    end

    tests("#list_server_public_addresses(#{@server.id}, 'private')").formats({'public' => [{'version' => Integer, 'addr' => String}]}) do
      Fog::Compute[:hp].list_server_public_addresses(@server.id, 'private').body
    end

    @address.destroy
    @server.destroy

  end

  tests('failure') do

    tests("#list_server_addresses(0)").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].list_server_addresses(0)
    end

    tests("#list_server_private_addresses(0, 'private')").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].list_server_private_addresses(0, 'private')
    end

    tests("#list_server_public_addresses(0, 'private')").raises(Fog::Compute::HP::NotFound) do
      Fog::Compute[:hp].list_server_public_addresses(0, 'private')
    end

  end

end
