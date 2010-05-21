Shindo.tests('Rackspace::Servers#delete_server', 'rackspace') do
  tests('success') do

    @server = Rackspace[:servers].servers.create(:flavor_id => 1, :image_id => 19, :name => 'foggetserverdetails')
    @server.wait_for { ready? }

    tests("#delete_server(#{@server.id})").succeeds do
      Rackspace[:servers].delete_server(@server.id)
    end

  end
  tests('failure') do

    tests('#delete_server(0)').raises(Excon::Errors::NotFound) do
      Rackspace[:servers].delete_server(0)
    end

  end
end
