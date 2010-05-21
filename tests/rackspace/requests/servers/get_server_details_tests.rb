Shindo.tests('Rackspace::Servers#get_server_details', 'rackspace') do
  tests('success') do

    @server = Rackspace[:servers].servers.create(:flavor_id => 1, :image_id => 19, :name => 'foggetserverdetails')

    tests("#get_server_details(#{@server.id})").formats(Rackspace::Servers::Formats::SERVER) do
      Rackspace[:servers].get_server_details(@server.id).body['server']
    end

    @server.wait_for { ready? }
    @server.destroy

  end
  tests('failure') do

    tests('#get_server_details(0)').raises(Excon::Errors::NotFound) do
      Rackspace[:servers].get_server_details(0)
    end

  end
end
