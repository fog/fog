Shindo.tests('Fog::Compute[:rackspace] | address requests', ['rackspace']) do

  @service = Fog::Compute.new(:provider => :rackspace, :version => :v1)

  tests('success') do

    @server = @service.servers.create(:flavor_id => 1, :image_id => 19)

    tests("#list_addresses(#{@server.id})").formats({'addresses' => {'private' => [String], 'public' => [String]}}) do
      @service.list_addresses(@server.id).body
    end

    tests("#list_private_addresses(#{@server.id})").formats({'private' => [String]}) do
      @service.list_private_addresses(@server.id).body
    end

    tests("#list_public_addresses(#{@server.id})").formats({'public' => [String]}) do
      @service.list_public_addresses(@server.id).body
    end

    @server.wait_for { ready? }
    @server.destroy

  end

  tests('failure') do

    tests('#list_addresses(0)').raises(Fog::Compute::Rackspace::NotFound) do
      @service.list_addresses(0)
    end

    tests('#list_private_addresses(0)').raises(Fog::Compute::Rackspace::NotFound) do
      @service.list_private_addresses(0)
    end

    tests('#list_public_addresses(0)').raises(Fog::Compute::Rackspace::NotFound) do
      @service.list_public_addresses(0)
    end

  end

end
