Shindo.tests('Fog::Compute[:rackspace] | address requests', ['rackspace']) do

  tests('success') do

    @server = Fog::Compute[:rackspace].servers.create(:flavor_id => 1, :image_id => 19)

    tests("#list_addresses(#{@server.id})").formats({'addresses' => {'private' => [String], 'public' => [String]}}) do
      Fog::Compute[:rackspace].list_addresses(@server.id).body
    end

    tests("#list_private_addresses(#{@server.id})").formats({'private' => [String]}) do
      Fog::Compute[:rackspace].list_private_addresses(@server.id).body
    end

    tests("#list_public_addresses(#{@server.id})").formats({'public' => [String]}) do
      Fog::Compute[:rackspace].list_public_addresses(@server.id).body
    end

    @server.wait_for { ready? }
    @server.destroy

  end

  tests('failure') do

    tests('#list_addresses(0)').raises(Fog::Compute::Rackspace::NotFound) do
      Fog::Compute[:rackspace].list_addresses(0)
    end

    tests('#list_private_addresses(0)').raises(Fog::Compute::Rackspace::NotFound) do
      Fog::Compute[:rackspace].list_private_addresses(0)
    end

    tests('#list_public_addresses(0)').raises(Fog::Compute::Rackspace::NotFound) do
      Fog::Compute[:rackspace].list_public_addresses(0)
    end

  end

end
