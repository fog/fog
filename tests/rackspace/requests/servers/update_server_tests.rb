Shindo.tests('Rackspace::Servers#update_server', 'rackspace') do
  tests('success') do

    @server = Rackspace[:servers].servers.create(:flavor_id => 1, :image_id => 19, :name => 'fogupdateserver')
    @server.wait_for { ready? }

    tests("#update_server(#{@server.id}, :name => 'fogupdatedserver', :adminPass => 'fogupdatedserver')").succeeds do
      Rackspace[:servers].update_server(@server.id, :name => 'fogupdatedserver', :adminPass => 'fogupdatedserver')
    end

    @server.destroy

  end
  tests('failure') do

    tests("#update_server(0, :name => 'fogupdatedserver', :adminPass => 'fogupdatedserver')").raises(Excon::Errors::NotFound) do
      Rackspace[:servers].update_server(0, :name => 'fogupdatedserver', :adminPass => 'fogupdatedserver')
    end

  end

end
