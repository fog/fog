Shindo.tests('Rackspace::Servers#list_public_addresses', 'rackspace') do
  tests('success') do

    @server = Rackspace[:servers].servers.create(:flavor_id => 1, :image_id => 19, :name => 'foglistpublicaddresses')

    tests("#list_public_addresses(#{@server.id})").formats({'public' => [String]}) do
      Rackspace[:servers].list_public_addresses(@server.id).body
    end

    @server.wait_for { ready? }
    @server.destroy

  end
  tests('failure') do

    tests('#list_public_addresses(0)').raises(Excon::Errors::NotFound) do
      Rackspace[:servers].list_public_addresses(0)
    end

  end

end
