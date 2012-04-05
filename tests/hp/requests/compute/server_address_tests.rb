Shindo.tests('Fog::Compute[:hp] | address requests', ['hp']) do

  tests('success') do
    @server = Fog::Compute[:hp].servers.create(:name => 'fogaddresstests', :flavor_id => 100, :image_id => 1242)

    # the network name is currently named 'private'
    tests("#list_server_addresses(#{@server.id})").formats({'addresses' => {"private" => [Hash]}}) do
      Fog::Compute[:hp].list_server_addresses(@server.id).body
    end

    tests("#list_server_private_addresses(#{@server.id}, 'private')").formats({'private' => [Hash]}) do
      Fog::Compute[:hp].list_server_private_addresses(@server.id, 'private').body
    end

    tests("#list_server_public_addresses(#{@server.id}, 'private')").formats({'public' => [Hash]}) do
      Fog::Compute[:hp].list_server_public_addresses(@server.id, 'private').body
    end

    @server.wait_for { ready? }
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
